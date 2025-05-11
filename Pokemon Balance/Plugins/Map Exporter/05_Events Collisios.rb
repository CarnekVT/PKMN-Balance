module MapExporterGenerator
    def self.drawEvents(map, passa_bitmap)
        for event in map.events.values
            width = 0
            height = 0
            if event.name[/size\((\d+),(\d+)\)/i]
                width = $~[1].to_i - 1
                height = $~[2].to_i - 1
            end
            x= event.x * 32
            y= event.y * 32
            passa_bitmap.fill_rect(
                x + 16 - (PASSA_EVENT_SIZE/2) - PASSA_EVENT_SIZE_OUTLINE,
                y + 16 - (PASSA_EVENT_SIZE/2) - PASSA_EVENT_SIZE_OUTLINE - (height * 2 * PASSA_EVENT_SIZE),
                (PASSA_EVENT_SIZE) + (PASSA_EVENT_SIZE_OUTLINE * 2) + (width * 2 * PASSA_EVENT_SIZE),
                (PASSA_EVENT_SIZE) + (PASSA_EVENT_SIZE_OUTLINE * 2) + (height * 2 * PASSA_EVENT_SIZE),
                PASSA_EVENT_COLOR2
            )
            passa_bitmap.fill_rect(
                x + 16 - (PASSA_EVENT_SIZE/2),
                y + 16 - (PASSA_EVENT_SIZE/2) - (height * 2 * PASSA_EVENT_SIZE),
                PASSA_EVENT_SIZE + (width * 2 * PASSA_EVENT_SIZE),
                PASSA_EVENT_SIZE + (height * 2 * PASSA_EVENT_SIZE),
                PASSA_EVENT_COLOR
            )
        end
    end
end