# Delete icon duplicate ~> base/element.scss .toast-{type(warning, success, info)}:before
window.incuboToastr = do ->
  # Assign or initialize the necessary variables and options
  initializeToastr = (options)->
    # Assign or initialize variables
    shortCutFunction = options.shortCutFunction
    msg = options.msg
    title = options.title or ''
    showDuration = options.showDuration or '400'
    hideDuration = options.hideDuration or '400'
    timeOut = options.timeOut or '7000'
    extendedTimeOut = options.extendedTimeOut or '3000'
    showEasing = options.showEasing or 'swing'
    hideEasing = options.hideEasing or 'linear'
    showMethod = options.showMethod or 'fadeIn'
    hideMethod = options.hideMethod or 'fadeOut'
    toastIndex = options.toastCount++ or 0

    # Object for alert type Toastr
    toastr.options =
      closeButton: options.closeButton or true
      debug: options.debug or false
      progressBar: options.progressBar or true
      preventDuplicates: options.preventDuplicates or true
      positionClass: options.positionClass or 'toast-top-right'
      onclick: null
      onHidden: ->
        $('.alert .notice').val ''
        return
      showDuration: showDuration
      hideDuration: hideDuration
      timeOut: timeOut
      extendedTimeOut: extendedTimeOut
      showEasing: showEasing
      hideEasing: hideEasing
      showMethod: showMethod
      hideMethod: hideMethod

    # Valid reload page
    if options.reloadPage
      toastr.options.onHidden = ->
        $('.alert .notice').val ''
        if options.reloadLocation
          window.location = options.reloadLocation
        else
          window.location.reload()
        return

    # Called Alert
    $toast = toastr[shortCutFunction](msg, title)
    return

  showToast = (options) ->
    initializeToastr options
    return

  show_alerts_or_notice = ->
    if $('#notifications').hasClass 'alert'
      type_notification = 'warning'
    else
      type_notification = 'success'
    typeToastr = type_notification
    message = ($('#notifications').html()).trim()
    if message != ''
      incuboToastr.showToast
        shortCutFunction: typeToastr
        msg: message
    return

  {
    showToast: showToast
    val_backend_messages: show_alerts_or_notice
  }