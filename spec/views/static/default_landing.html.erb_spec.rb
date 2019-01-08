require 'rails_helper'

describe '/static/default_landing' do
  it 'renders single column with 100% width' do
    @config = {
        'rows' => [
          {
                'columns' => [
                  {
                        'entities' => [
                          {
                                'type' => 'text',
                                'text' => {
                                    'content' => 'A test',
                                },
                            },
                        ],
                    },
                ],
            },
        ],
    }

    erb = File.read("#{Rails.root}/app/views/static/default_landing.html.erb")
    actual = ERB.new(erb).result(binding)

    expected_output = <<~HEREDOC
    <div class="Vlt-grid"> <div class="Vlt-col"> A test </div> </div>
    HEREDOC

    # .squish() erb output to remove extranous newlines and whitespaces & .chomp trailing newline off expected_output
    expect(actual.squish).to eq(expected_output.chomp)
  end

  it 'renders two columns with 50% width each' do
  end

  it 'renders three columns' do
  end

  it 'renders three columns (1:2, 1:1 and 1:1 width)' do
  end

  it 'renders two columns (1:1 and 1:2)' do
  end
end

# describe '/static/default_landing' do
#     it 'renders a single row with two columns and a default width' do

#         allow(LandingPageBlockRenderer::Text).to receive(:render).exactly(2).times and_return("")
#         allow(LandingPageBlockRenderer::JoinSlack).to receive(:render).once and_return("")
#         allow(LandingPageBlockRenderer::GithubRepo).to receive(:render).once and_return("")

#         receive().once
#         receive().twice
#         receive().exactly(3).times

#         page_config = {
#             "rows" => [
#                 {
#                     "columns" => [
#                         {
#                             "entities" => [
#                                 {
#                                     "type" => "text",
#                                     "text" => {
#                                         "content" => "This is a test"
#                                     }
#                                 },
#                                 {
#                                     "type" => "text",
#                                     "text" => {
#                                         "content" => "Another Text Block"
#                                     }
#                                 }
#                         ]
#                         },
#                         {
#                             "entities" => [
#                                 {
#                                     "type" => "join_slack"
#                                 },
#                                 {
#                                     "type" => "github_repo",
#                                     "github_repo" => {
#                                         "name" => "nexmo/nexmo-php"
#                                     }
#                                 }
#                             ]
#                         }
#                     ]
#                 }
#             ]
#         }

#         pageRenderer.render(page_config)
#     end

#     it 'renders a single row with two columns and a default width' do

#         allow(LandingPageBlockRenderer::Text).to receive(:render). and_return("")
#         allow(LandingPageBlockRenderer::JoinSlack).to receive(:render). and_return("")
#         allow(LandingPageBlockRenderer::GithubRepo).to receive(:render). and_return("")
#         page_config = {
#             "rows" => [
#                 {
#                     "columns" => [
#                         {
#                             "entities" => [{
#                                 "type" => "text",
#                                 "text" => {
#                                     "content" => "This is a test"
#                                 }
#                             }]
#                         },
#                         {
#                             "entities" => [
#                                 {
#                                     "type" => "join_slack"
#                                 },
#                                 {
#                                     "type" => "github_repo",
#                                     "github_repo" => {
#                                         "name" => "nexmo/nexmo-php"
#                                     }
#                                 }
#                             ]
#                         }
#                     ]
#                 }
#             ]
#         }

#         current = the current block being rendered
#         renderer = get_renderer(current['type'])
#         renderer.render(current)

#         TextBlockRenderer
#         JoinSlackBlockRenderer
#         GithubRepoBlockRenderer
#         HtmlBlockRenderer

#         erb = File.read("#{Rails.root}/app/views/static/default_landing.html.erb")
#         actual = ERB.new(erb).result(binding)

#         expected = <~~ HEREDOC
#         <div class="row">
#         <div class="column">
#         </div>
#         <div class="column">
#         </div>
#         </div>
#         HEREDOC
#     end
# end

# def get_renderer(type)
#     case type
#     when 'text'
#         LandingPageBlockRenderer::Text
#     when 'join_slack'
#         LandingPageBlockRenderer::JoinSlack
#     else
#       raise "Unknown block type: #{type}"
#     end
# end

# module LandingPageBlockRenderer
#     class Text
#         def self.render(params)
#             <~~HEREDOC
#             <p class="block-text">‹{params['text']['content']}</p>
#             HEREDOC
#         end
#     end
# end
