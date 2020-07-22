require 'rails_helper'

RSpec.describe TaskDecorator do
  include_context 'with logged in user with project and task'
  let(:decorated_task) { task.decorate }

  describe '#status' do
    subject(:task_status) { decorated_task.status }

    context 'with success type' do
      before { decorated_task.update(is_done: true) }

      it 'returns done' do
        expect(task_status).to eq('Done')
      end
    end

    context 'with expired deadline' do
      before do
        allow_any_instance_of(described_class).to receive(:time_left).and_return(-1)
      end

      it 'returns time is out' do
        expect(task_status).to eq('Time is out')
      end
    end
  end

  describe '#time_class' do
    subject(:task_time_classes) { decorated_task.time_class }

    context 'when task is done' do
      before { decorated_task.update(is_done: true) }

      it 'returns success classes' do
        expect(task_time_classes).to eq('text-success border border-success')
      end
    end

    context 'with time left more than 86 400' do
      before do
        allow_any_instance_of(described_class).to receive(:time_left).and_return(87_000)
      end

      it 'returns dark classes' do
        expect(task_time_classes).to eq('text-dark border border-dark')
      end
    end

    context 'with time left more than 3600' do
      before do
        allow_any_instance_of(described_class).to receive(:time_left).and_return(3700)
      end

      it 'returns warning classes' do
        expect(task_time_classes).to eq('text-warning border border-warning')
      end
    end

    context 'with time left less than 3600' do
      before do
        allow_any_instance_of(described_class).to receive(:time_left).and_return(3000)
      end

      it 'returns danger classes' do
        expect(task_time_classes).to eq('text-danger border border-danger')
      end
    end
  end
end
