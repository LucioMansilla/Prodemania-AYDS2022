# frozen_string_literal: true

module ExportPdfHelper
  class StructuredPdf
    def initialize(table, title)
      @title = title
      @table = table
    end

    attr_accessor :title, :table
  end

  def points_table_data(id_tournament)
    points = Point.where(tournament_id: id_tournament).order(total_points: :desc)
    data_table = [['#', 'Nombre', 'Puntos']]
    i = 1
    points.each do |p|
      player = p.player[:name].to_s
      point = p[:total_points].to_s
      data_table.push([i.to_s, player, point])
      i += 1
    end

    StructuredPdf.new(data_table, "Puntaje #{Tournament.find_by(id: id_tournament).name}")
  end

  def create_pdf(data)
    content_type 'application/pdf'
    pdf = Prawn::Document.new
    create_footer(create_table(create_styles(create_canvas(pdf), data), data)).render
  end

  def create_canvas(pdf)
    pdf.canvas do
      pdf.fill_color '242424'
      pdf.fill_rectangle [pdf.bounds.left, pdf.bounds.top], pdf.bounds.right, pdf.bounds.top
    end
    pdf
  end

  def create_styles(pdf, data)
    pdf.image open('public/images/logo.png'), position: :left, width: 300
    pdf.font 'Times-Roman'
    pdf.fill_color 'f2f2f2'
    pdf.move_down 20
    pdf.text data.title, align: :center, size: 30, style: :bold, margin: [0, 100, 0, 0]
    pdf.move_down 20
    pdf
  end

  def create_footer(pdf)
    pdf.bounding_box([pdf.bounds.left, pdf.bounds.bottom + 50], width: pdf.bounds.width) do
      pdf.text '© 2022 - Todos los derechos reservados a Prodemania', align: :center, size: 12,
                                                                      style: :bold, margin: [0, 0, 0, 0]
    end
    pdf
  end

  def create_table(pdf, data)
    pdf.table(data.table, position: :center, width: 500,
                          cell_style: { size: 10, font: 'Helvetica', font_style: :bold,
                                        border_color: '3aa17a', padding: 12, align: :center,
                                        inline_format: true }) do
      (0..data.table.length - 1).each do |i|
        row(i).border_color = '242424'
        row(i).text_color = '242424'
        row(i).background_color = '3aa17a'
        unless i.zero?
          row(i).text_color = 'f2f2f2'
          row(i).background_color = '242424'
        end
      end
    end
    pdf
  end
end
