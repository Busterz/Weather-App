<body>
	<h2>Hello User!</h2>
	<label for='weather-date'>Pick a date: </label>
	<input type='date' id='weather-date' name='weather-date'>
	<button type="button" id='request-weather-list'>Request</button>
	</br></br>
	<table class='locations-table'>
		<thead>
			<tr>
				<th colspan='2'>List of Available Locations</th>
			</tr>
			<tr>
				<th>ID</th>
				<th>Location</th>
			</tr>
		</thead>
		<tbody id='locations-head'>
		</tbody>
	</table>
	<p class='loader' style='display:none;'>Loading...</p>
	</br>
	<p>Latest 10 hours data:</p>
	<table class='temperature-table'>
		<thead>
			<tr>
				<th colspan='3'>List of Weather-Locations</th>
			</tr>
			<tr>
				<th>Station ID</th>
				<th>Station Location</th>
				<th>Temperature</th>
			</tr>
		</thead>
		<tbody id='temperature-head'>
		</tbody>
	</table>
	<p class='loader' style='display:none;'>Loading...</p>
	
	<script>
	$(document).ready(function(){
		const url = 'https://api.data.gov.sg/v1/environment/air-temperature?date=';
		
		let today = new Date();
		let dd = String(today.getDate()).padStart(2, '0');
		let mm = String(today.getMonth() + 1).padStart(2, '0');
		let yyyy = today.getFullYear();
		today = yyyy + '-' + mm + '-' + dd;
		$('#weather-date').attr('max',today);
		$('#weather-date').val(today);
		
		$('#request-weather-list').click(function() {
		    let date = $('#weather-date').val();
		    $('.loader').show();
		    
		    $.ajax({
				type: "GET",
				url: url + date,
				success: function(res) {
					let json = res;
					let stations = json.metadata.stations;
					let stationsList = {};
					let tbData = '';
					$.each(stations, function(ind, val) {
					  stationsList[val.id] = val.name;
						
					  let tData = '<tr>';
					  tData += '<td>' + val.id + '</td>';
					  tData += '<td>' + val.name + '</td>';
					  tData += '</tr>';
					  
					  tbData += tData;
					});
					$('#locations-head').html(tbData);
					tbData = '';
					
					let twentyFourHrData = json.items;
					let twentyFourHrDataSize = twentyFourHrData.length;
					let counter = 0;
					//console.log('=======latest 10=======');
					let hrArr = [];
					for(let i=twentyFourHrDataSize-60; i<twentyFourHrDataSize; i-=60){
						counter++;
						if(counter === 11) break;
						else{
							let hrData = twentyFourHrData[i];
							hrArr.push(hrData);
						}
					}
					
					//console.log(stationsList);
					for(let j=0; j<hrArr.length; j++){
						let time = hrArr[j];
						let timeDay = time.timestamp.split('T')[1].slice(0,8);
						let timeHeader = '';
						timeHeader += '<tr>';
						timeHeader += '<td colspan="3" style="text-align:center;">' + timeDay + '</td>';
						timeHeader += '</tr>';
						tbData += timeHeader;
						 
						let timeReadings = time.readings;
						for(let k=0; k<timeReadings.length; k++){
							let id = timeReadings[k].station_id;
							let temp = timeReadings[k].value;
							let name = stationsList[id];
							
							let tData = '<tr>';
							tData += '<td>' + id + '</td>';
							tData += '<td>' + name + '</td>';
							tData += '<td>' + temp + '</td>';
							tData += '</tr>';
							  
							tbData += tData;
						}
					}
					$('#temperature-head').html(tbData);
					$('.loader').hide();
				}
			});
		});
	});
	</script>
</body>