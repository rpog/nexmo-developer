class CollapsibleFilter < Banzai::Filter
  def call(input)
    input.gsub(/^\|\s(\#{1,6})(\s)?(.+?)\n^\|\n(.+?)\n\n/m) do |_s|
      heading = $3
      body = $4.gsub(/^\|\n/, "\n")
      body = body.gsub(/^\|\s/, '')
      parsed_body = MarkdownPipeline.new.call(body)

      <<~HEREDOC
        <div class="Vlt-accordion">
          <button class="Vlt-accordion__trigger">
            #{heading}
          </button>
          <div class="Vlt-accordion__content">
            #{parsed_body}
          </div>
        </div>
      HEREDOC
    end
  end
end
