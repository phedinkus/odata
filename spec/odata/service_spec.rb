require 'spec_helper'

describe OData::Service, vcr: {cassette_name: 'service_specs'} do
  let(:subject) { OData::Service.open('https://graph.microsoft.com/v1.0', name: 'MicrosoftGraph') }

  let(:entity_types) { %w{entity directoryObject device directoryRole directoryRoleTemplate group conversationThread calendar outlookItem event conversation profilePhoto drive subscribedSku organization user message mailFolder calendarGroup contact contactFolder attachment fileAttachment itemAttachment eventMessage referenceAttachment post driveItem permission thumbnailSet} }
  let(:entity_sets) { %w{directoryObjects devices groups directoryRoles directoryRoleTemplates organization subscribedSkus users drives} }
  let(:entity_set_types) { %w{directoryObject device group directoryRole directoryRoleTemplate organization subscribedSku user drive} }
  let(:complex_types) { %w{alternativeSecurityId licenseUnitsDetail servicePlanInfo assignedPlan provisionedPlan verifiedDomain assignedLicense passwordProfile reminder dateTimeTimeZone location physicalAddress itemBody recipient emailAddress responseStatus patternedRecurrence recurrencePattern recurrenceRange attendee identitySet identity quota itemReference audio deleted file hashes fileSystemInfo folder image geoCoordinates photo searchResult shared specialFolder video sharingInvitation sharingLink thumbnail} }
  let(:associations) { [] }

  describe '.open' do
    it { expect(OData::Service).to respond_to(:open) }
  end

  it 'adds itself to OData::ServiceRegistry on creation' do
    expect(OData::ServiceRegistry['MicrosoftGraph']).to be_nil
    expect(OData::ServiceRegistry['https://graph.microsoft.com/v1.0']).to be_nil

    service = OData::Service.open('https://graph.microsoft.com/v1.0', name: 'MicrosoftGraph')

    expect(OData::ServiceRegistry['MicrosoftGraph']).to eq(service)
    expect(OData::ServiceRegistry['https://graph.microsoft.com/v1.0']).to eq(service)
  end

  describe 'instance methods' do
    it { expect(subject).to respond_to(:service_url) }
    it { expect(subject).to respond_to(:entity_types) }
    it { expect(subject).to respond_to(:entity_sets) }
    it { expect(subject).to respond_to(:complex_types) }
    it { expect(subject).to respond_to(:associations) }
    it { expect(subject).to respond_to(:namespace) }
  end

  describe '#service_url' do
    it { expect(subject.service_url).to eq('https://graph.microsoft.com/v1.0') }
  end

  describe '#entity_types' do
    it { expect(subject.entity_types.size).to eq(30) }
    it { expect(subject.entity_types.map(&:name)).to eq(entity_types) }
  end

  describe '#entity_sets' do
    it { expect(subject.entity_sets.size).to eq(9) }
    it { expect(subject.entity_sets.keys).to eq(entity_set_types) }
    it { expect(subject.entity_sets.values).to eq(entity_sets) }
  end

  describe '#complex_types' do
    it { expect(subject.complex_types.size).to eq(40) }
    it { expect(subject.complex_types).to eq(complex_types) }
  end

  describe '#associations' do
    it { expect(subject.associations.size).to eq(0) }
    it { expect(subject.associations.keys).to eq(associations) }
    it do
      subject.associations.each do |name, association|
        expect(association).to be_a(OData::Association)
      end
    end
  end

  describe '#navigation_properties' do
    it { expect(subject).to respond_to(:navigation_properties) }
    it { expect(subject.navigation_properties['user'].size).to eq(18) }
    xit { expect(subject.navigation_properties['user']['ownedDevices']).to be_a(OData::Association) }
  end

  describe '#namespace' do
    it { expect(subject.namespace).to eq('microsoft.graph') }
  end

  describe '#[]' do
    it { expect(subject['directoryObjects']).to be_a(OData::EntitySet) }
    it { expect {subject['Nonexistant']}.to raise_error(ArgumentError) }
  end
end
