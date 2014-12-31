Sequel.migration do
  change do
    create_table(:data) do
      primary_key :id
      foreign_key :url_id
      DateTime :requested_at
      Integer :responded_in
      foreign_key :referral_id
      String :request_type
      String :params
      foreign_key :event_id
      foreign_key :user_agent_id
      foreign_key :resolution_id
      String :ip
      foreign_key :source_id
    end

    create_table(:urls) do
      primary_key :id
      String :name
    end

    create_table(:referrals) do
      primary_key :id
      String :name
    end

    create_table(:events) do
      primary_key :id
      String :name
    end

    create_table(:user_agents) do
      primary_key :id
      String :data
      String :os
      String :browser
    end

    create_table(:resolutions) do
      primary_key :id
      String :width
      String :height
    end
  end
end
