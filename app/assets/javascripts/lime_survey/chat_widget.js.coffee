##
# Individual text message
#
class window.LimeSurvey.IndividualMsg
    ##
    constructor: (msg, time, cls) ->
        @msg = msg
        @time = time
        @cls = cls

        

## 
# Stores all messages
# - Serialize / Deserialize
# It takes the input from textarea and turn into messages.
# It takes the token data into messages.

class window.LimeSurvey.ChatMessages
    ##
    # A new chat_messages collection
    constructor: (node) ->
        @node = node
        @messages = []
        @load_textarea_data(node)
        @load_token_data(node)
        @sort_messages()
        return

    ##
    # css class right
    load_textarea_data: (node) ->
        node.find('textarea').text()
        @messages = $($.parseJSON(node.find('textarea').text()) || []).toArray()
        for val, idx in @messages
            val.push('right')
            @messages[idx] = val
        @messages
        return

    ##
    # css class left
    load_token_data: (node) ->
        arr = $($.parseJSON(node.find('blockquote').text()) || []).toArray() 
        for val, idx in arr
            arr[idx][2] = 'left'
        @messages = @messages.concat(arr)
        return @messages
    
    sort_messages: ->
        @messages.sort (a,b) ->
            return (a[0] > b[0])

    deserialize: ->
        @node.find('textarea').text(JSON.stringify(@messages))

    format_date: (date) ->
        curr_date = [date.getFullYear(), (date.getMonth() + 1), date.getDate()].join("/")
        curr_time = [date.getHours(), date.getMinutes(), date.getSeconds()].join(":")
        timeStamp = [curr_date, curr_time].join(" ")

        RE_findSingleDigits = /\b(\d)\b/g

        # Places a `0` in front of single digit numbers.
        timeStamp = timeStamp.replace( RE_findSingleDigits, "0$1" )
        timeStamp.replace /\s/g, ""
        return timeStamp
    ##
    # Store a new message
    add: (msg) ->
        time = new Date()
        cls = 'left'
        result = [time, msg, cls]
        @messages.push result
        @deserialize()
        return result

       
    ##
    # Remove a message
    remove: (idx) ->
        return

    ##        @time_stamp = new Date().getTime()dd/1000
    #
    # Serialize all messages
    serialize: (json_string) ->

        obj = JSON.parse(json_string)
        for msg in obj
            @arry_msg.push(obj[msg])
        return @arry_msg
##
# Base Object, does event handling and user interaction
class window.LimeSurvey.ChatWidget 
    constructor: (@node) -> 
        @container = $('<div>', class:'chat-widget-container')
        @viewer = $('<div>', class:'chat-widget-viewer')
        @input = $('<input>', class:'chat-widget-input')

        
        return
   
    start: ->
        @build()
        @load_messages()
        @event_handlers()

    isJsonString: (str) ->
        try
            return JSON.parse(str)
        catch
            return false


    ##
    # Load JSON string from textarea into view window (viewer)
    # Load JSON data from token data.
    load_messages: ->
        @chat_messages = new window.LimeSurvey.ChatMessages(@node)
        klass = @
        $(@chat_messages.messages).each ->
            time = this[0]
            msg = this[1]
            cls = this[2]
            klass.add_message(time, msg, cls)

    # Hide node and add chat interface to the DOM
    build: ->
        #@node.hide()
        @node.after(@container.append(@viewer).append(@input))
        

    ##
    # Initialize event handlers
    event_handlers: ->
        klass = @
        # Prevent form submission on enter key press
        @input.on 'keyup keypress', (e)->
          code = e.keyCode || e.which;
          return unless code == 13
          # disable submit
          e.preventDefault();
          # notify of new message
          msg = klass.input.val()
          klass.input.val('')
          return if msg == ''
          m = klass.chat_messages.add(msg)
          klass.add_message(m[0], m[1], m[2])

    ##
    # Add a message to chat box
    add_message: (time, msg, cls) ->
        @viewer.append(
            $('<div>', class: 'row').append(
                $('<div>', text: msg, class: cls).append( 
                    $('<small/>', text:time)
                )
            )
        )
    
    ##
    # Remove a message from chat box
    remove_message: (idx) ->
        return

jQuery(document).ready ->
    $ = jQuery

    $('head').append("""
    <style id='dynamicStylesheet' type='text/css'>
        .chat-widget-container{
            min-height: 100px;
            border: 1px solid purple;
            background-color: orange;
            font-size:18px;
        }
        .chat-widget-viewer{
            min-height: 85px;
            width: 90%;
            background-color: #fdfdfd;
            border: 1px solid #555;
            overflow: hidden; /*match child height*/
        }
        .chat-widget-viewer .left{
            float: left;
            clear: both;
            display: inline-block;
            max-width: 80%;
            border: 2px solid blue;
            background-color: #EAF1FB;
            border-radius: 25px;
            margin: 5px;
            padding: 10px;
            margin-left: 20px;
        }
        .chat-widget-viewer .right{
            float: right;
            clear: both;
            display: inline-block;
            max-width: 80%;
            border: 2px solid green;
            background-color: #EAFFEF;
            border-radius: 25px;
            margin: 5px;
            padding: 10px;
            margin-left: 35%;
        }
        .chat-widget-viewer small{
            display: block;
            font-size: 0.6em;
        }
        .chat-widget-input{
            margin-left: auto;
            margin-right: auto;
            min-height: 25px;
            width: 90%;
            background-color: #ddd;
            border: 1px solid #555;
        }

    </style>""")

    $('div.ls-chat-widget').each ->
        $node = $(this).parents('.question-wrapper')
        $widget = new LimeSurvey.ChatWidget($node)
        $widget.start()

