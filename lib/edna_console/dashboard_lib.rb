module EdnaConsole
    module DashboardLib
        ###
        # Collision Detector Errors
        #
        module Errors
            # Collision occurred when setting indecies
            CollisionError = Class.new(StandardError)
            # Stopped looking before a spot was found for rectangle 
            ExhaustedError = Class.new(StandardError)
            # The widget is too wide to place on the given desktop
            WidgetTooWideError = Class.new(StandardError)
        end

        ###
        # Creates a 2d array and maps items of different sizes to them
        # - Used to ensure proper placement of desktop widgets
        class CollisionDetector
            attr_accessor :cm, :max_cols
            
            ###
            # Optionally set the maximum number of columns on 2d array
            #
            def initialize opts={}
                @max_cols = opts[:max_cols] || 5
                @cm = opts[:cm] || []
            end
            
            ###
            # Register a rectangle in the collision matrix (cm) 
            # - Returns: index of insertion point if succeeds
            # - Or throws an error stating why it failed
            def register_rectangle pos, sizex, sizey, rid=1
                raise Errors::WidgetTooWideError unless sizex <= max_cols
                
                # maximum number of times to try
                200.times do |attempt_num|
                    # calculate what indecies this rectangle inhabits
                    indecies = indexes_of pos + attempt_num, sizex, sizey
                    
                    # too close to max_cols
                    next if indecies.nil?
                    
                    # check for collisions
                    next if cm.values_at(*indecies).compact.size > 0
                    
                    # mark spot as taken
                    set_indecies indecies, rid
                    
                    # return the start of the spot that was registered
                    return indecies
                end
                raise Errors::ExhaustedError
            end
            
            ###
            # return all of the indexes that are occupied by the 
            # following rectangle
            #            
            def indexes_of pos, sizex, sizey
                indecies = []
                c_col, c_row = pos_to_coord pos
                return nil if c_col+sizex > max_cols
                
                sizex.times do |p_x|
                    # add indecies for every row and col
                    sizey.times do |p_y|
                        n_pos = coord_to_pos c_col+p_x, c_row+p_y
                        indecies.push n_pos
                    end
                end
                return indecies
            end
            
            ###
            # Set the value of these indecies to rid
            # - Effectively take ownership of the indexes
            def set_indecies indecies, rid=1
                indecies.each do |val|
                    raise Errors::CollisionError unless cm[val].nil?
                    cm[val] = rid
                end
            end
            
            ###
            # get the col and row of this position
            #
            def pos_to_coord val
                [val % max_cols, (val / max_cols).to_i ]
            end
            
            ###
            # get the position of this col and row
            #
            def coord_to_pos col, row
                row*max_cols + col
            end
        end
    end
end
