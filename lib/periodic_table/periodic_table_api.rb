require 'savon'

module PeriodicTable

  class PeriodicTableApi
    def initialize
      @client = Savon.client(wsdl: "http://www.webservicex.net/periodictable.asmx?WSDL")
    end

    def query(element_name)
      api_response = @client.call(:get_atomic_number, message: { 'ElementName' => element_name })
      result = api_response.to_hash[:get_atomic_number_response][:get_atomic_number_result]
      ApiResponse.new(result)
    end
  end

  class ApiResponse
    attr_reader :atomic_weight, :symbol, :atomic_number, :element_name, :boiling_point, :ionisation_potential, :electro_negativity, :atomic_radius, :melting_point, :density

    def initialize(result)
      xml = Nokogiri::XML.parse(result)
      @atomic_weight = xml.at('AtomicWeight').text
      @symbol = xml.at('Symbol').text
      @atomic_number = xml.at('AtomicNumber').text
    end
  end

end

