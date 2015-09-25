$ ->
    $.ajax
        dataType: "json"
        url: "api/infographics"
        success: (data)->
            c = $("<div class='container'/>").appendTo "body"
            $("<img src='/i/#{data.url}' class='img-rounded' style='width:100%;'/>").appendTo c
            $("<pre>#{JSON.stringify(data)}</pre>").appendTo c

