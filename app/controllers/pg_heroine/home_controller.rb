module PGHeroine
  class HomeController < ActionController::Base
    layout "pgheroine/application"

    protect_from_forgery

    http_basic_authenticate_with name: ENV["PGHEROINE_USERNAME"], password: ENV["PGHEROINE_PASSWORD"] if ENV["PGHEROINE_PASSWORD"]

    before_filter :set_query_stats_enabled

    def index
      @title = "Status"
      @slow_queries = PGHeroine.slow_queries
      @long_running_queries = PGHeroine.long_running_queries
      @index_hit_rate = PGHeroine.index_hit_rate
      @table_hit_rate = PGHeroine.table_hit_rate
      @missing_indexes = PGHeroine.missing_indexes
      @unused_indexes = PGHeroine.unused_indexes
      @good_cache_rate = @table_hit_rate >= 0.99 && @index_hit_rate >= 0.99
      @query_stats_available = PGHeroine.query_stats_available?
      @total_connections = PGHeroine.total_connections
      @good_total_connections = @total_connections < PGHeroine.total_connections_threshold
      @connection_sources = PGHeroine.connection_sources.first(10)
      @slow_query_ms = PGHeroine.slow_query_ms
      @slow_query_calls = PGHeroine.slow_query_calls
    end

    def indexes
      @title = "Indexes"
      @index_usage = PGHeroine.index_usage
    end

    def space
      @title = "Space"
      @database_size = PGHeroine.database_size
      @relation_sizes = PGHeroine.relation_sizes
    end

    def queries
      @title = "Live Queries"
      @running_queries = PGHeroine.running_queries
    end

    def query_stats
      @title = "Queries"
      @query_stats = PGHeroine.query_stats
    end

    def system_stats
      @title = "System Stats"
      @cpu_usage = PGHeroine.cpu_usage.map{|k, v| [k, v.round] }
      @connection_stats = PGHeroine.connection_stats
    end

    def explain
      @title = "Explain"
      @query = params[:query]
      # TODO use get + token instead of post so users can share links
      # need to prevent CSRF and DoS
      if request.post? and @query
        begin
          @explanation = PGHeroine.explain(@query)
        rescue ActiveRecord::StatementInvalid => e
          @error = e.message
        end
      end
    end

    def tune
      @title = "Tune"
      @settings = PGHeroine.settings
    end

    def kill
      if PGHeroine.kill(params[:pid])
        redirect_to root_path, notice: "Query killed"
      else
        redirect_to :back, notice: "Query no longer running"
      end
    end

    def kill_all
      PGHeroine.kill_all
      redirect_to :back, notice: "Connections killed"
    end

    def enable_query_stats
      begin
        PGHeroine.enable_query_stats
        redirect_to :back, notice: "Query stats enabled"
      rescue ActiveRecord::StatementInvalid => e
        redirect_to :back, alert: "The database user does not have permission to enable query stats"
      end
    end

    def reset_query_stats
      begin
        PGHeroine.reset_query_stats
        redirect_to :back, notice: "Query stats reset"
      rescue ActiveRecord::StatementInvalid => e
        redirect_to :back, alert: "The database user does not have permission to reset query stats"
      end
    end

    protected

    def set_query_stats_enabled
      @query_stats_enabled = PGHeroine.query_stats_enabled?
      @system_stats_enabled = PGHeroine.system_stats_enabled?
    end

  end
end
