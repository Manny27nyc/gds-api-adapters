require "test_helper"
require "gds_api/fact_cave"

describe GdsApi::FactCave do
  it "should raise an exception if the service at the search URI returns a 500" do
    stub_request(:get, /example.com\/facts/).to_return(status: [500, "Internal Server Error"])
    assert_raises(GdsApi::HTTPErrorResponse) do
      GdsApi::FactCave.new("http://example.com").fact("foo")
    end
  end

  it "should raise an exception if the service at the search URI returns a 404" do
    stub_request(:get, /example.com\/facts/).to_return(status: [404, "Not Found"])
    assert_raises(GdsApi::HTTPNotFound) do
      GdsApi::FactCave.new("http://example.com").fact("bar")
    end
  end

  it "should raise an exception if the service at the search URI times out" do
    stub_request(:get, /example.com\/facts/).to_timeout
    assert_raises(GdsApi::TimedOutException) do
      GdsApi::FactCave.new("http://example.com").fact("meh")
    end
  end

  it "should return the fact deserialized from json" do
    fact_cave_result = {"id" => "vat-rate", "title" => "VAT rate", "details" => { 
      "value" => "20%", "description" => "Value Added Tax rate" }}
    stub_request(:get, /example.com\/facts/).to_return(body: fact_cave_result.to_json)
    results = GdsApi::FactCave.new("http://example.com").fact("vat-rate")

    assert_equal fact_cave_result, results.to_hash
  end

  it "should return an empty result without making request if slug is empty" do
    results = GdsApi::FactCave.new("http://example.com").fact("")

    assert_equal "", results
    assert_not_requested :get, /example.com/
  end
end
