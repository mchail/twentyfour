#= require ../vendor/bootstrap/js/bootstrap.min

$ ->
	run = ->
		nums = $('#nums').val().split(/[^\d]+/).join(',')
		$answers = $('#answers')
		$answers.empty()
		$answers.append($('<p>').text('calculating...'))
		$.get('/solve?n=' + nums, (data) ->
			$answers.empty()
			window.data = data
			data.forEach((val) ->
				$answers.append($('<li>').text(val))
			)
			if data.length == 0
				$answers.append($('<p>').text('no results'))
		).fail((data) ->
			$answers.empty()
			$answers.append($('<p>').text('took too long to process'))
		)
	$('form').submit ->
		run()
		return false
	$('#example').click ->
		$('#nums').val('8 8 3 3')
		run()
