module Admin
  class UsersController < BaseController
    PER_PAGE = 20

    # GET /api/admin/users
    def index
      entries = base_scope
      entries = apply_sorting(entries)
      entries = entries.page(params[:page]).per(PER_PAGE)

      render json: {
        users: entries.map { |e| serialize_user(e) },
        meta: pagination_meta(entries)
      }
    end

    # GET /api/admin/users/:id
    def show
      entry = find_entry!
      return unless entry
      render json: { user: serialize_user(entry) }
    end

    # PATCH/PUT /api/admin/users/:id
    def update
      entry = find_entry!
      return unless entry

      if entry.update(update_params)
        render json: { user: serialize_user(entry) }
      else
        render json: { errors: entry.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/admin/users/:id (soft-delete / deactivate)
    def destroy
      entry = find_entry!
      return unless entry
      entry.deactivate!
      render json: { user: serialize_user(entry), message: "User deactivated" }
    end

    private

    def base_scope
      if ActiveModel::Type::Boolean.new.cast(params[:include_deactivated])
        WaitingListEntry.all
      else
        WaitingListEntry.active
      end
    end

    def find_entry
      @find_entry_result ||= WaitingListEntry.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def find_entry!
      entry = find_entry
      unless entry
        render json: { error: "User not found" }, status: :not_found
        return
      end
      entry
    end

    def update_params
      params.permit(:name, :email, :status)
    end

    def apply_sorting(scope)
      sort = params[:sort] || "created_at"
      direction = params[:direction] || "desc"

      allowed_sorts = %w[name email created_at]
      sort = "created_at" unless allowed_sorts.include?(sort)

      direction = "desc" unless %w[asc desc].include?(direction)

      scope_name = :"order_by_#{sort}_#{direction}"
      if scope.respond_to?(scope_name)
        scope.public_send(scope_name)
      else
        scope.order(created_at: :desc)
      end
    end

    def serialize_user(entry)
      {
        id: entry.id,
        name: entry.name,
        email: entry.email,
        subscribed_at: entry.subscribed_at&.iso8601,
        status: entry.status,
        created_at: entry.created_at&.iso8601,
        updated_at: entry.updated_at&.iso8601
      }
    end

    def pagination_meta(entries)
      {
        current_page: entries.current_page,
        total_pages: entries.total_pages,
        total_count: entries.total_count,
        per_page: PER_PAGE
      }
    end
  end
end