# -*- encoding : utf-8 -*-
require_relative 'spec_helper'

describe Cequel::Util::Forwardable do
  let(:person) { Struct.new(:first_name, :last_name).new('Mat', 'Brown') }

  let(:klass) do
    Class.new do
      extend Cequel::Util::Forwardable

      attr_reader :person

      def initialize(person)
        @person = person
      end
    end
  end

  subject { klass.new(person) }

  describe '#delegate' do
    it 'should delegate a single method to the target' do
      klass.delegate :first_name, to: :person
      expect(subject.first_name).to eq('Mat')
    end

    it 'should delegate several methods to the target' do
      klass.delegate :first_name, :last_name, to: :person
      expect(subject.first_name).to eq('Mat')
      expect(subject.last_name).to eq('Brown')
    end

    it 'should pass options through to ActiveSupport' do
      klass.delegate :first_name, :last_name, to: :person, prefix: true
      expect(subject.person_first_name).to eq('Mat')
      expect(subject.person_last_name).to eq('Brown')
    end

    it 'should still support the Forwardable hash form' do
      klass.delegate [:first_name, :last_name] => :person
      expect(subject.first_name).to eq('Mat')
      expect(subject.last_name).to eq('Brown')
    end

    it 'should raise ArgumentError when no target is given' do
      expect { klass.delegate :first_name, :last_name }
        .to raise_error(ArgumentError)
    end
  end
end
