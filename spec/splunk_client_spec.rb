require File.expand_path File.join(File.dirname(__FILE__), 'spec_helper')

describe SplunkClient do

  before :each do
    @user = ENV['SPLUNK_USER']
    @pass = ENV['SPLUNK_PASSWD']
    @host = ENV['SPLUNK_HOST']
    @splunk_client = SplunkClient.new(@user, @pass, @host)
  end

  context "initialization" do

    it "creates a session key" do
      splunk_client = @splunk_client
      splunk_client.should_not be(nil)
      splunk_client.send(:get_session_key).should_not be(nil)
    end

  end

  context "searching" do

    it "creates a search job and returns results" do
      splunk_client = @splunk_client
      splunk_client.should_not be(nil)
      search = 'source="/var/log/messages" "kernel" earliest=-10m'
      job = splunk_client.search(search)
      job.should_not be(nil)
      job.wait
      job.results(0, 'json')
      job.cancel
    end

  end
  
  context "parsing_results" do
    it "uses the parsedResults 'host' method of a SplunkJob" do
      splunk_client = @splunk_client
      splunk_client.should_not be(nil)
      search = 'source="/var/log/messages" "kernel" earliest=-10m'
      job = splunk_client.search(search)
      job.should_not be(nil)
      job.wait
      results = job.parsedResults
      
      # Test the auto generated methods
      results.each do |result|
        result.respond_to?("time").should be(true)
        result.respond_to?("host").should be(true)
        result.time.should_not be(nil)
        result.host.should_not be(nil)
      end

    end
  end

end