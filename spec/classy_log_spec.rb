require 'spec_helper'

class KlassWithoutLog
  include ClassyLog
end

class KlassWithLog
  include ClassyLog

  def initialize(log)
    @log = log
  end
end

describe ClassyLog do
  let(:external_log) { Logger.new('/dev/null') }

  it 'has a version number' do
    expect(ClassyLog::VERSION).not_to be nil
  end

  context 'mixed-into' do
    describe KlassWithoutLog do
      let(:obj) { KlassWithoutLog.new }
      subject { obj }

      it { is_expected.to respond_to(:log) }
      describe '#log' do
        subject(:obj_log) { obj.log }
        it { is_expected.to be_a(Logger) }
        it { expect(obj_log.level).to eq(ClassyLog::Logging::DEFAULT_LOG_LEVEL) }
        it { expect(obj_log.progname).to eq(obj.class.name) }
      end

      it { is_expected.to respond_to(:log=) }
      describe '#log=' do
        before { obj.log = external_log }
        subject(:obj_log) { obj.log }
        it { is_expected.to eq(external_log) }
      end

      context 'class' do
        subject(:klass) { KlassWithoutLog }
        it { is_expected.to respond_to(:log) }
        describe '.log' do
          subject(:obj_log) { klass.log }
          it { is_expected.to be_a(Logger) }
          it { expect(obj_log.level).to eq(ClassyLog::Logging::DEFAULT_LOG_LEVEL) }
          it { expect(obj_log.progname).to eq(klass.name) }
        end

        it { is_expected.to_not respond_to(:pretty_print_mode) }
        it { is_expected.to_not respond_to(:pretty_print_mode=) }
        it { is_expected.to_not respond_to(:global_level) }
        it { is_expected.to_not respond_to(:global_level=) }
        it { is_expected.to_not respond_to(:log_for) }
        it { is_expected.to_not respond_to(:configure_log_for) }

        describe '.global_level=' do
          let(:level) { Logger::ERROR }
          let(:objs) { [KlassWithoutLog.new, KlassWithoutLog.new, KlassWithoutLog.new] }
          before do
            ClassyLog::Logging.global_level = level
            @log_levels = objs.map { |obj| obj.log.level }
          end

          it { expect(@log_levels).to all(be level) }
          it { expect(@log_levels).to_not include(ClassyLog::Logging::DEFAULT_LOG_LEVEL) }
        end
      end
    end

    describe KlassWithLog do
      let(:obj) { KlassWithLog.new(external_log) }
      subject { obj }

      it { is_expected.to respond_to(:log) }
      describe '#log' do
        subject(:obj_log) { obj.log }
        it { is_expected.to be_a(Logger) }
        it { expect(obj_log.level).to eq(ClassyLog::Logging::DEFAULT_LOG_LEVEL) }
        it { expect(obj_log.progname).to eq(obj.class.name) }
      end
    end
  end
end
