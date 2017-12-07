require 'packlink_lite/version'
require 'packlink_lite/configuration'
require 'packlink_lite/errors'
require 'packlink_lite/client'
require 'packlink_lite/service'
require 'packlink_lite/order'
require 'packlink_lite/shipment'
require 'packlink_lite/label'
require 'packlink_lite/tracking_history'

module PacklinkLite
  module_function

  def configure
    yield(config)
  end

  def config
    @configuration ||= Configuration.new
  end

  def client
    @client ||= Client.new
  end

  def change_shipment_callback_url(url)
    client.post('shipments/callback', { url: url }, parse_response: false)
  end

  def change_tracking_callback_url(url)
    client.post('shipments/tracking_callback', { url: url }, parse_response: false)
  end
end
