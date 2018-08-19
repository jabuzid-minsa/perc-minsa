var geography_search = (function () {
    // Get asynchronous for the levels of the country
    function ajax_elements_per_level(ajax_data, current_level, level) {
        $.ajax({
            url: ajax_data.url[current_level],
            type: "GET",
            dataType: "json",
            data: ajax_data.parameters,
            contentType: "application/json; charset=utf-8",
            success: function(data) {
                ajax_data.dom_element[level].empty();
                ajax_data.dom_element[level].append('<option value="">'+ ajax_data.blank_option[level] +'</option>');
                $.each(data, function (index, val) {
                    ajax_data.dom_element[level].append(
                        '<option value="'+val.id+'" data-code="'+val[level]+'">'+val.description+'</option>'
                    );
                });
            },
            error: function(xhr,exception,status) {
                console.log("error");
                console.log(xhr);
                console.log(exception);
                console.log(status);
            }
        });
    }
    
    // Object of geographic levels
    function get_geography_levels() {
        var geography_levels = { first_level: "first_level", second_level: "second_level", third_level: "third_level",
                fourth_level: "fourth_level", fifth_level: "fifth_level"
            },
            keys_array = Object.keys(geography_levels),
            object_size = keys_array.length;

        return {
            keys: keys_array,
            levels: geography_levels,
            size: object_size
        };
    }

    // Get next item from object
    function get_next_key(current_level, current_level_value) {
        var data = get_geography_levels(),
            increments = typeof current_level_value !== "undefined" ? 1 : 0,
            hide_key = typeof current_level_value !== "undefined" ? 2 : 1,
            next_index = data.keys.indexOf(current_level) + increments;
        //
        hide_levels(data.keys, data.keys.indexOf(current_level) + hide_key, data.size);
        //
        show_level(data.keys[next_index]);
        //
        return data.keys[next_index];
    }

    // Hide levels according to current level and selected value
    function hide_levels(keys, index, total) {
        var elements = keys.slice(index, total);
        if (index + 1 < total){
            $.each(elements, function (index, value) {
                $("#" + value).parent().hide("slow");
                $("#" + value).select2({"allowClear": true, "val": ""});
            });
        }
    }

    //
    function set_geography_id(current_level_option_value, dom_geography_id, country_id) {
        var val = current_level_option_value !== "" ? current_level_option_value : country_id;
        $(dom_geography_id).val(val);
    }

    // Show next level according to current level
    function show_level(level) {
        var id_element = "#" + level;
        $(id_element).parent().show("slow");
    }

    // Function that calls the other functions to start the process
    function start_process(toggle, select_geography, ajax_data) {
        var next_level = get_next_key(toggle.current_level, toggle.current_level_value);
        set_geography_id(select_geography.current_level_option_value, select_geography.dom_geography_id, select_geography.country_id);

        if (valid_access_ajax(toggle.current_level, ajax_data.size_country)){
            if (next_level != 'second_level') {
                ajax_elements_per_level(ajax_data, toggle.current_level, next_level)
            }
        }
    }

    //
    function valid_access_ajax(current_level, depth_country){
        var data = get_geography_levels();
        return data.keys.indexOf(current_level) < (depth_country - 1)
    }

    // Public objects accessible by calling the object "geography_search"
    return {
        start_process: start_process
    };
})();