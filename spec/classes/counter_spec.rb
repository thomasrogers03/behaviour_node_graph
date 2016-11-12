require 'rspec'

module BehaviourNodeGraph
  describe Counter do

    let(:context) { Context.new }
    let(:target) { Faker::Lorem.word }
    let(:increment) { rand(1...1000) }
    let(:initial_value) { nil }

    subject { Counter.new_node(target, increment) }

    before { context.values[target] = initial_value }

    describe '.inputs' do
      subject { Counter }
      its(:inputs) { is_expected.to eq([:target]) }
    end

    describe '.properties' do
      subject { Counter }
      its(:properties) { is_expected.to eq(increment: :int) }
    end

    it { is_expected.to be_a_kind_of(Node) }

    describe '#act' do
      before do
        subject.context = context
        subject.act
      end

      it 'sets the current value of the target to the increment' do
        expect(context.values[target]).to eq(increment)
      end

      context 'with a previously existing value' do
        let(:initial_value) { rand(1...1000) }

        it 'updates the target to the original value plus the increment' do
          expect(context.values[target]).to eq(initial_value + increment)
        end
      end
    end

  end
end
