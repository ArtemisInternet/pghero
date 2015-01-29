module PGHeroine
  class HomeController < ActionController::Base
    layout "pgheroine/application"

    protect_from_forgery

    http_basic_authenticate_with name: ENV["PGHEROINE_USERNAME"], password: ENV["PGHEROINE_PASSWORD"] if ENV["PGHEROINE_PASSWORD"]

    def index
      @title = "Status"

      @slow_queries = query_coordinator.slow_queries
      @long_running_queries = query_coordinator.long_running_queries
      @index_hit_rate = query_coordinator.index_hit_rate
      @table_hit_rate = query_coordinator.table_hit_rate
      @missing_indexes = query_coordinator.missing_indexes
      @unused_indexes = query_coordinator.unused_indexes
      @good_cache_rate = @table_hit_rate >= 0.99 && @index_hit_rate >= 0.99
      @query_stats_available = query_coordinator.query_stats_available?
      @total_connections = query_coordinator.total_connections
      @good_total_connections = @total_connections < query_coordinator.total_connections_threshold
      @connection_sources = query_coordinator.connection_sources.first(10)
      @slow_query_ms = query_coordinator.slow_query_ms
      @slow_query_calls = query_coordinator.slow_query_calls
    end

    def indexes
      @title = "Indexes"
      @index_usage = query_coordinator.index_usage
    end

    def space
      @title = "Space"
      @database_size = query_coordinator.database_size
      @relation_sizes = query_coordinator.relation_sizes
    end

    def queries
      @title = "Live Queries"
      @running_queries = query_coordinator.running_queries
    end

    def query_stats
      @title = "Queries"
      @query_stats = query_coordinator.query_stats
    end

    def system_stats
      @title = "System Stats"
      @cpu_usage = query_coordinator.cpu_usage.map{|k, v| [k, v.round] }
      @connection_stats = query_coordinator.connection_stats
    end

    def tune
      @title = "Tune"
      @settings = query_coordinator.settings
    end

    private

    def set_query_stats_enabled
      @query_stats_enabled = query_coordinator.query_stats_enabled?
      @system_stats_enabled = query_coordinator.system_stats_enabled?
    end

    def query_coordinator
      @query_coordinator ||= QueryCoordinator.new(params[:database_name].to_sym)
    end
  end
end
