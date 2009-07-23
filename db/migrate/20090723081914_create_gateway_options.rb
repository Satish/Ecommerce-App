class CreateGatewayOptions < ActiveRecord::Migration
  def self.up
    create_table :gateway_options do |t|
      t.string :name
      t.references :store_gateway
      t.text :description

      t.timestamps
    end
    StoreGateway.all.each do |sg|
      sg.gateway_options << GatewayOption.create(GATEWAY_OPTIONS[sg.gateway.name])
    end
  end

  def self.down
    drop_table :gateway_options
  end
end
