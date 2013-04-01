
$ ->
	run = ->
		nums = $('#nums').val().split(/[^\d]+/).join(',')
		$answers = $('.answers')
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
		)
	$('form').submit ->
		run()
		return false
