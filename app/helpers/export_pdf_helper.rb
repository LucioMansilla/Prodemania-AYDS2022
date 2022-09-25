module ExportPdfHelper

    class StructuredPdf
        def initialize(table,title)
            @title = title
            @table = table
        end
        
          def title
            @title
          end

          def table
            @table
          end
        
          def table=(table)
            @table = table
          end

          def title=(title)
            @title = title
          end
    end 

    def points_table_data(id_tournament)
        points = Point.where(tournament_id:id_tournament).order(total_points: :desc)
        name_tournament = Tournament.find_by(id: id_tournament).name

        data_table = [["#","Nombre","Puntos"]]

        i = 1
        for p in points do 
            player = p.player[:name].to_s
            point = p[:total_points].to_s
            data_table.push([i.to_s,player, point])
            i = i+1
        end 

        data = StructuredPdf.new(data_table,"Puntaje "+name_tournament)

        return data
    end

    def create_pdf(data)

        content_type 'application/pdf'
        pdf = Prawn::Document.new
        #pdf = Prawn::Document.new(
         #   background: "#242424"
          #)

        content = data.title
        pdf.font "Times-Roman"
        pdf.fill_color "3aa17a"
        pdf.draw_text content, :at => [150,720], :size => 30
        pdf.move_down 20
        pdf.fill_color "f2f2f2"
        pdf.table(
        data.table, :width => 500, :cell_style => {
          :font_style => :bold, :background_color => '242424', :border_color => '3aa17a'  } )
        pdf.render

    end
    
end