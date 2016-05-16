require 'rspec'

module BehaviourNodeGraph
  describe Counter do

    let(:context) { Context.new }
    let(:target) { Faker::Lorem.word }
    let(:lhs) { Faker::Lorem.sentence }
    let(:rhs) { Faker::Lorem.sentence }
    let(:lhs_value) { 1 }
    let(:rhs_value) { 0 }
    let(:operator) { :gt }
    let(:comparer) { Comparer.new_node(target, lhs, rhs, operator) }

    subject { comparer }

    before do
      context.values[lhs] = lhs_value
      context.values[rhs] = rhs_value
    end

    it { is_expected.to be_a_kind_of(Node) }

    describe '#act' do
      subject { context.values[target] }

      before do
        comparer.context = context
        comparer.act
      end

      describe 'strictly greater than' do
        it { is_expected.to eq(true) }

        context 'with an equal rhs' do
          let(:rhs_value) { 1 }
          it { is_expected.to eq(false) }
        end

        context 'with a greater rhs' do
          let(:rhs_value) { 2 }
          it { is_expected.to eq(false) }
        end
      end

      describe 'strictly less than' do
        let(:operator) { :lt }

        it { is_expected.to eq(false) }

        context 'with an equal rhs' do
          let(:rhs_value) { 1 }
          it { is_expected.to eq(false) }
        end

        context 'with a greater rhs' do
          let(:rhs_value) { 2 }
          it { is_expected.to eq(true) }
        end
      end

      describe 'greater than or equal to' do
        let(:operator) { :ge }

        it { is_expected.to eq(true) }

        context 'with an equal rhs' do
          let(:rhs_value) { 1 }
          it { is_expected.to eq(true) }
        end

        context 'with a greater rhs' do
          let(:rhs_value) { 2 }
          it { is_expected.to eq(false) }
        end
      end

      describe 'less than or equal to' do
        let(:operator) { :le }

        it { is_expected.to eq(false) }

        context 'with an equal rhs' do
          let(:rhs_value) { 1 }
          it { is_expected.to eq(true) }
        end

        context 'with a greater rhs' do
          let(:rhs_value) { 2 }
          it { is_expected.to eq(true) }
        end
      end

      describe 'strictly equal to' do
        let(:operator) { :eq }

        it { is_expected.to eq(false) }

        context 'with an equal rhs' do
          let(:rhs_value) { 1 }
          it { is_expected.to eq(true) }
        end

        context 'with a greater rhs' do
          let(:rhs_value) { 2 }
          it { is_expected.to eq(false) }
        end
      end
    end

  end
end
