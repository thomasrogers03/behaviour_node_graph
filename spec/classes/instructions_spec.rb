require 'rspec'

module BehaviourNodeGraph
  describe Instructions do

    let(:attribute) { Faker::Lorem.word }

    it { is_expected.to be_a_kind_of(OpenStruct) }

    it { expect(subject.public_send(attribute)).to be_a_kind_of(Instructions) }

    context 'when a previous values has been set' do
      let(:previous_value) { Faker::Lorem.sentence }

      before { subject.public_send(:"#{attribute}=", previous_value) }

      it { expect(subject.public_send(attribute)).to eq(previous_value) }
    end

  end
end
