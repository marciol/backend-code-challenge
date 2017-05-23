class RefreshDistancesGraphWorker
	include Sidekiq::Worker

	def perform(repository = DistancesGraphRepository.new)
		repository.refresh_graph
	end
end