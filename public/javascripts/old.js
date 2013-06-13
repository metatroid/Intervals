function moveToAction(action, project){
	actionContainer = "."+action+"Container";
	history.pushState({ action: action, project: project  }, '', "/home/"+action);
	$(".application").animate({
		left: "-710px"
	}, 400);
	$(actionContainer).show().html("<span class='icon loadAction'>0</span>");
	var loaderSymbols = ['0', '1', '2', '3', '4', '5', '6', '7']; 
	var loaderIndex = 0;
	loadAction = setInterval(function(){
		loaderIndex = loaderIndex  < loaderSymbols.length - 1 ? loaderIndex + 1 : 0;
		$(actionContainer).find('.loadAction').html(loaderSymbols[loaderIndex]);
	}, 100);
	
	$.post( '/actions', {
		projectAction: action,
		projectId: project
		}, function(){
			clearInterval(loadAction);
			$(actionContainer).find('.loadAction').html("");
	});
}

function isNumberKey(evt){
  var charCode = (evt.which) ? evt.which : event.keyCode
  if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)){
  	return false;
  }
  return true;
 }

$(document).ready(function(){
	
	
	
	//select
	$('.select ul li a:not(".mainSettings")').live("click", function(event){
		event.preventDefault();
		$(".action").html("");
		$('.active').removeClass("active");
		$(this).parent().addClass('active');
		var project = "0", action = $(this).attr('data-action');
		
		$(".projects").html("<span class='icon loadAction'>0</span>");
		var loaderSymbols = ['0', '1', '2', '3', '4', '5', '6', '7']; 
		var loaderIndex = 0;
		loadAction = setInterval(function(){
			loaderIndex = loaderIndex  < loaderSymbols.length - 1 ? loaderIndex + 1 : 0;
			$(".projects").find('.loadAction').html(loaderSymbols[loaderIndex]);
		}, 100);
		history.pushState({ action: "home", project: $(this).attr('data-project_id') }, '', "/home");
		$(".application").animate({
			left: "0"
		}, 400);
		$.post( '/actions', {
			projectAction: action,
			projectId: project
			}, function(){
				clearInterval(loadAction);
				$(".projects").find('.loadAction').html("");
		});
	});
	
	$(".mainSettings").live("click", function(event){
		event.preventDefault();
		$('.active').removeClass("active");
		$(this).parent().addClass('active');
		$(".action").html("");
		var project = "0", projectAction = $(this).attr('data-action');
		moveToAction(projectAction, project);
	});
	//end select
	
	//new project
	$('.newProject').live('click', function(event){
		event.preventDefault();
		$('.newProjectForm').slideDown(200);
		$('#project_projectlogo').css({opacity: 0}).live('change', function(){
			$('.fakefile').val($(this).val());
		});
	});
	$('.cancelProject').live('click', function(event){
		event.preventDefault();
		$(this).closest('form').find('input[type=text], textarea').val("");
		$('#project_projectlogo').replaceWith('<input id="project_projectlogo" name="project[projectlogo]" type="file">');
		$('.newProjectForm').slideUp(200);
		clearInterval(submitting);
		submitting = null;
		$(this).siblings('.icon').html("");
	});
	$('#project_submit').live('click', function(event){
		var that = this;
		var loaderSymbols = ['0', '1', '2', '3', '4', '5', '6', '7']; 
		var loaderIndex = 0;
		submitting = setInterval(function(){
			loaderIndex = loaderIndex  < loaderSymbols.length - 1 ? loaderIndex + 1 : 0;
			$(that).siblings('.icon').html(loaderSymbols[loaderIndex]);
		}, 100);
	});
	
	//end new project
	
	//project edit
	$('#project_edit_submit').live('click', function(event){
		var that = this;
		var loaderSymbols = ['0', '1', '2', '3', '4', '5', '6', '7']; 
		var loaderIndex = 0;
		submitting = setInterval(function(){
			loaderIndex = loaderIndex  < loaderSymbols.length - 1 ? loaderIndex + 1 : 0;
			$(that).siblings('.icon').html(loaderSymbols[loaderIndex]);
		}, 100);
	});
	$(".cancelProjectEdit").live("click", function(event){
		event.preventDefault();
		$(".application").animate({
			left: "0"
		}, 400);
		$(".settingsContainer").slideUp(200, function(){
			$(".action").html("");
		});
	});
	//end edit
	
	//inerval controls
	$('.startTimer').live('click', function(event){
		event.preventDefault();
		var that = this;
		if($(this).attr('class').indexOf('stopped') != -1){
			$(this).removeClass('stopped').html("<span class='icon loading'>0</span> Stop Timer");
			var loaderSymbols = ['0', '1', '2', '3', '4', '5', '6', '7']; 
			var loaderIndex = 0;
			that.loading = setInterval(function(){
				loaderIndex = loaderIndex  < loaderSymbols.length - 1 ? loaderIndex + 1 : 0;
				$(that).find('.loading').html(loaderSymbols[loaderIndex]);
			}, 100);
			var user = $(this).attr('data-user_id');
			var project = $(this).attr('data-project_id');
			var timestamp = Date.now();
			var date = new Date(timestamp);
			var month = date.getMonth();
			var day = date.getDate();
			var hour = date.getHours();
			var minute = date.getMinutes();
			var year = date.getFullYear();
			$.post('/users/'+user+'/projects/'+project+'/intervals', {
				start: year +', ' + month + ', ' + day + ', ' + hour + ', ' + minute + ' ('+timestamp+')',
				projectId: project,
				method: "timer"
			});
		} else {
			clearInterval(that.loading);
			$(this).addClass('stopped').html("<span class='icon'>P</span> Start Timer");
			var user = $(this).attr('data-user_id');
			var project = $(this).attr('data-project_id');
			var interval = $(this).siblings('.timerResponse').find('.intervalTimer').attr('class').replace(/\D/g, '');
			var timestamp = Date.now();
			var date = new Date(timestamp);
			var month = date.getMonth();
			var day = date.getDate();
			var hour = date.getHours();
			var minute = date.getMinutes();
			var year = date.getFullYear();
			$.ajax({
				type: 'PUT',
				url: '/users/'+user+'/projects/'+project+'/intervals/'+interval,
				data: {
					end: year +', ' + month + ', ' + day + ', ' + hour + ', ' + minute + ' ('+timestamp+')',
					projectId: project,
					intervalId: interval
				} 
			});
		}
	});
	
	$('.saveInterval').live("click", function(event){
		event.preventDefault();
		var user = $(this).attr('data-user_id'), project = $(this).attr('data-project_id'), interval = $(this).attr('data-interval_id');
		var note = $(this).siblings('input').val();
		$.ajax({
			type: 'PUT',
			url: '/users/'+user+'/projects/'+project+'/intervals/'+interval,
			data: {
				description: note,
				projectId: project,
				intervalId: interval
			} 
		});
	});
	$('.cancelInterval').live("click", function(event){
		event.preventDefault();
		var user = $(this).attr('data-user_id'), project = $(this).attr('data-project_id'), interval = $(this).attr('data-interval_id');
		var forSures = confirm("Permanently delete this work period?");
		if(forSures){
			$.ajax({
				type: 'DELETE',
				url: '/users/'+user+'/projects/'+project+'/intervals/'+interval,
				data: {
					projectId: project,
					intervalId: interval
				} 
			});
		} else {
			return false;
		}
	});
	$(".deleteInterval").live("click", function(event){
		event.preventDefault();
		var user = $(this).attr('data-user_id'), project = $(this).attr('data-project_id'), interval = $(this).attr('data-interval_id');
		var forSures = confirm("Permanently delete this work period?");
		if(forSures){
			$.ajax({
				type: 'DELETE',
				url: '/users/'+user+'/projects/'+project+'/intervals/'+interval,
				data: {
					method: "manual",
					projectId: project,
					intervalId: interval
				} 
			});
		} else {
			return false;
		}
	});
	$(".editInterval").live("click", function(event){
		event.preventDefault();
		var user = $(this).attr('data-user_id'), project = $(this).attr('data-project_id'), interval = $(this).attr('data-interval_id');
		var originalNote = $(this).closest(".controls").siblings(".note").clone();
		$(this).closest(".controls").siblings(".note").replaceWith('<div class="enterDescription"><input id="description" name="description" placeholder="Description" type="text" value=""></div>');
		var originalDuration = $(this).closest(".controls").siblings(".duration").clone();
		$(this).closest(".controls").siblings(".duration").replaceWith('<div class="enterMinutes"><input id="total" name="total" onkeypress="return isNumberKey(event)" placeholder="Minutes" type="text" value=""></div>');
		var originalDelete = $(this).closest(".edit").siblings(".delete").clone();
		$(this).closest(".edit").siblings(".delete").replaceWith('<div class="cancel icon"><a href="#" class="editIntervalCancel">×</a></div>');
		var originalEdit = $(this).parent().clone();
		$(this).parent().replaceWith('<div class="icon save"><a href="#" class="editIntervalSave">/</a></div>');
		$(".editIntervalCancel").click(function(event){
			event.preventDefault();
			$(this).parent().siblings(".save").replaceWith(originalEdit);
			$(this).closest('.controls').siblings(".enterDescription").replaceWith(originalNote);
			$(this).closest('.controls').siblings(".enterMinutes").replaceWith(originalDuration);
			$(this).parent().replaceWith(originalDelete);
		});
		$(".editIntervalSave").click(function(event){
			event.preventDefault();
			var note = $(this).closest(".controls").siblings(".enterDescription").find("input").val(), duration = $(this).closest(".controls").siblings(".enterMinutes").find("input").val();
			$(this).parent().siblings(".cancel").replaceWith(originalDelete);
			$(this).closest('.controls').siblings(".enterDescription").replaceWith(originalNote);
			$(this).closest(".controls").siblings(".note").html("");
			$(this).closest('.controls').siblings(".enterMinutes").replaceWith(originalDuration);
			$(this).closest(".controls").siblings(".duration").html("");
			$(this).parent().replaceWith(originalEdit);
			$.ajax({
				type: 'PUT',
				url: '/users/'+user+'/projects/'+project+'/intervals/'+interval,
				data: {
					method: "manual",
					description: note,
					time: duration,
					projectId: project,
					intervalId: interval
				},
				success: function(){
					clearInterval(updatinginterval);
					$("a.newInterval").siblings('.loading').html("");
				}
			});
			var loaderSymbols = ['0', '1', '2', '3', '4', '5', '6', '7']; 
			var loaderIndex = 0;
			updatinginterval = setInterval(function(){
				loaderIndex = loaderIndex  < loaderSymbols.length - 1 ? loaderIndex + 1 : 0;
				$("a.newInterval").siblings('.loading').html(loaderSymbols[loaderIndex]);
			}, 100);
		});
	});
	//end interval controls
	
	//invoice controls
	$(".invoiceAction").live("click", function(event){
		event.preventDefault();
		var project = $(this).attr('data-project_id'), invoice = $(this).attr('data-invoice_id'), command = $(this).attr("title"), user = $(this).attr('data-user_id');
		if(command == "Save"){
			window.location = "/invoice/actions?projectId="+project+"&invoiceId="+invoice;
		} else if(command == "Preview") {
			$.post("/invoice/actions", {
				invoiceAction: command,
				projectId: project,
				invoiceId: invoice
			}, function(){
				clearInterval(previewing);
				$('.loading').html("");
			});
			var that = this;
			var loaderSymbols = ['0', '1', '2', '3', '4', '5', '6', '7']; 
			var loaderIndex = 0;
			previewing = setInterval(function(){
				loaderIndex = loaderIndex  < loaderSymbols.length - 1 ? loaderIndex + 1 : 0;
				$(that).closest("ul").siblings(".newInvoice").find('.loading').html(loaderSymbols[loaderIndex]);
			}, 100);
		} else {
			var forSures = confirm("Permanently delete this invoice?");
			if(forSures){
				var loaderSymbols = ['0', '1', '2', '3', '4', '5', '6', '7']; 
				var loaderIndex = 0;
				deleting = setInterval(function(){
					loaderIndex = loaderIndex  < loaderSymbols.length - 1 ? loaderIndex + 1 : 0;
					$(".invoice-"+invoice+" .icon").eq(0).html(loaderSymbols[loaderIndex]);
				}, 100);
				
				$.ajax({
					type: 'DELETE',
					url: '/users/'+user+'/projects/'+project+'/invoices/'+invoice,
					data: {
						invoiceAction: command,
						projectId: project,
						invoiceId: invoice
					},
					success: function(){
						clearInterval(deleting);
					}
				});
			} else {
				return false;
			}
		}
	});
	//end invoice controls
	
	//project controls
	$(".projectAction").live("click", function(event){
		event.preventDefault();
		var project = $(this).attr('data-project_id'), projectAction = $(this).attr('data-action');
		moveToAction(projectAction, project);
	});
	
	$(".actionReturn").live("click", function(event){
		event.preventDefault();
		history.pushState({ action: "home", project: $(this).attr('data-project_id') }, '', "/home");
		$(".application").animate({
			left: "0"
		}, 400);
		clearInterval(loadAction);
		loadAction = null;
		$(".action").html("");
	});
	
	$(".projectDelete").live("click", function(event){
		event.preventDefault();
		var project = $(this).attr('data-project_id'), user = $(this).attr('data-user_id');
		var forSures = confirm("Permanently delete this project?");
		if(forSures){
			$.ajax({
				type: 'DELETE',
				url: '/users/'+user+'/projects/'+project,
				data: {
					projectId: project
				} 
			});
		} else {
			return false;
		}
	});
	$(".projectOpen").live("click", function(event){
		event.preventDefault();
		event.stopPropagation();
		var production = $(this).attr("data-pro_url"), development = $(this).attr("data-dev_url");
		if($(".linkWrapper").length > 0){
			$(".linkWrapper").fadeOut(200, function(){
				$(".linkWrapper").remove();
			});
		} else {
			var linkContainer = document.createElement("div");
			$(linkContainer).addClass("linkWrapper");
			$(linkContainer).html("<div class='linksArrow'></div><div class='linkContainer'><ul><li><a href='"+production+"' target='_blank' title='production url'>Production</a></li><li><a href='"+development+"' target='_blank' title='development url'>Development</a></li></ul></div>");
			$(this).closest(".clientControls").append(linkContainer);
			$(linkContainer).fadeIn(400);
			$(document).click(function(event){
				event.stopPropagation();
				$(".linkWrapper").fadeOut(200, function(){
					$(".linkWrapper").remove();
					
				});
			})
		}
	});
	//end project controls
	
	//mail
	$('#submit_email').live("click", function(){
		var that = this;
		var loaderSymbols = ['0', '1', '2', '3', '4', '5', '6', '7']; 
		var loaderIndex = 0;
		sendingMail = setInterval(function(){
			loaderIndex = loaderIndex  < loaderSymbols.length - 1 ? loaderIndex + 1 : 0;
			$(that).siblings('.icon').html(loaderSymbols[loaderIndex]);
		}, 100);
	});
	$(".editItem").live("click", function(event){
		event.preventDefault();
		if($(this).siblings(".edit").is(":visible")){
			$(this).siblings(".edit").slideUp(200);
		} else {
			$(this).siblings(".edit").slideDown(200);
		}
	});
	//end mail
	
	// history
	var popped = ('state' in window.history), initialURL = location.href
	$(window).bind("popstate", function(e) {
		var initialPop = !popped && location.href == initialURL
		popped = true
		if ( initialPop ) return
		
		history.pushState({ action: "home", project: $(this).attr('data-project_id') }, '', "/home");
		$(".application").animate({
			left: "0"
		}, 400);
		
		$(".action").html("");
		
	});
	//end history
});
