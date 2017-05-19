require 'spec_helper'

describe RefreshDistancesGraphWorker do
	describe '#perform' do

		let(:repository) { DistancesGraphRepository.new }
		let(:worker) { RefreshDistancesGraphWorker.new }

		it 'calls #refresh_graph on DistancesGraphRepository instance' do
			repository.stub :refresh_graph, :ok do
				worker.perform(repository).must_equal :ok
			end
		end
	end
end
