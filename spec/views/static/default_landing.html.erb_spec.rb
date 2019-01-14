require 'rails_helper'

RSpec.describe 'static/default_landing.html.erb', type: :view do
  describe 'GET default_landing' do
    it 'renders single column with 100% width' do
      @config = {
          'rows' => [
            {
                'columns' => [
                  {
                        'entries' => [
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

      expect(YAML).to_receive(:load_file).and_return(@config)

      expected_output = <<~HEREDOC
        <div class=\"Vlt-grid\"> <div class=\"row\"> <div class=\"Vlt-col\"> A test </div> </div> </div>
      HEREDOC

      # .squish() erb output to remove extranous newlines and whitespaces & .chomp trailing newline off expected_output
      expect(actual).to eq(expected_output.chomp)
    end

    it 'renders two columns with 50% width each' do
      @config = {
          'rows' => [
            {
                  'columns' => [
                    {
                          'width' => 1,
                          'entries' => [
                            {
                                  'type' => 'text',
                                  'text' => {
                                      'content' => 'Column 1',
                                  },
                              },
                          ],
                      },
                    {
                          'width' => 1,
                          'entries' => [
                            {
                                  'type' => 'text',
                                  'text' => {
                                      'content' => 'Column 2',
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
        <div class=\"Vlt-grid\"> <div class=\"row\"> <div class=\"Vlt-col--1of2\"> Column 1 </div> <div class=\"Vlt-col--1of2\"> Column 2 </div> </div> </div>
      HEREDOC

      # .squish() erb output to remove extranous newlines and whitespaces & .chomp trailing newline off expected_output
      expect(actual.squish).to eq(expected_output.chomp)
    end

    it 'renders three columns, no width specified' do
      @config = {
          'rows' => [
            {
                  'columns' => [
                    {
                          'entries' => [
                            {
                                  'type' => 'text',
                                  'text' => {
                                      'content' => 'Column 1',
                                  },
                              },
                          ],
                      },
                    {
                          'entries' => [
                            {
                                  'type' => 'text',
                                  'text' => {
                                      'content' => 'Column 2',
                                  },
                              },
                          ],

                    },
                    {
                      'entries' => [
                        {
                              'type' => 'text',
                              'text' => {
                                  'content' => 'Column 3',
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
        <div class=\"Vlt-grid\"> <div class=\"row\"> <div class=\"Vlt-col\"> Column 1 </div> <div class=\"Vlt-col\"> Column 2 </div> <div class=\"Vlt-col\"> Column 3 </div> </div> </div>
      HEREDOC

      # .squish() erb output to remove extranous newlines and whitespaces & .chomp trailing newline off expected_output
      expect(actual.squish).to eq(expected_output.chomp)
    end

    it 'renders two columns in three-column grid (1:2 and 1:1)' do
      @config = {
          'rows' => [
            {
                  'columns' => [
                    {
                          'width' => 2,
                          'entries' => [
                            {
                                  'type' => 'text',
                                  'text' => {
                                      'content' => 'Column 1',
                                  },
                              },
                          ],
                      },
                    {
                      'width' => 1,
                      'entries' => [
                        {
                              'type' => 'text',
                              'text' => {
                                  'content' => 'Column 2',
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
        <div class=\"Vlt-grid\"> <div class=\"row\"> <div class=\"Vlt-col--2of3\"> Column 1 </div> <div class=\"Vlt-col--1of3\"> Column 2 </div> </div> </div>
      HEREDOC

      # .squish() erb output to remove extranous newlines and whitespaces & .chomp trailing newline off expected_output
      expect(actual.squish).to eq(expected_output.chomp)
    end

    it 'renders two columns in three-column grid (1:1 and 1:2)' do
      @config = {
          'rows' => [
            {
                  'columns' => [
                    {
                          'width' => 1,
                          'entries' => [
                            {
                                  'type' => 'text',
                                  'text' => {
                                      'content' => 'Column 1',
                                  },
                              },
                          ],
                      },
                    {
                      'width' => 2,
                      'entries' => [
                        {
                              'type' => 'text',
                              'text' => {
                                  'content' => 'Column 2',
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
        <div class=\"Vlt-grid\"> <div class=\"row\"> <div class=\"Vlt-col--1of3\"> Column 1 </div> <div class=\"Vlt-col--2of3\"> Column 2 </div> </div> </div>
      HEREDOC

      # .squish() erb output to remove extranous newlines and whitespaces & .chomp trailing newline off expected_output
      expect(actual.squish).to eq(expected_output.chomp)
    end

    it 'renders two rows, one with two columns (1:1) and one with three (1:1:1)' do
      @config = {
          'rows' => [
            {
              'columns' => [
                {
                  'width' => 1,
                  'entries' => [],
                },
                {
                  'width' => 1,
                  'entries' => [],
                },
              ],
            },
            {
              'columns' => [
                {
                  'width' => 1,
                  'entries' => [],
                },
                {
                  'width' => 1,
                  'entries' => [],
                },
                {
                  'width' => 1,
                  'entries' => [],
                },
              ],
            },
          ],
        }
      erb = File.read("#{Rails.root}/app/views/static/default_landing.html.erb")
      actual = ERB.new(erb).result(binding)

      expected_output = <<~HEREDOC
        <div class="Vlt-grid"> <div class="row"> <div class="Vlt-col--1of2"> </div> <div class="Vlt-col--1of2"> </div> </div> <div class="row"> <div class="Vlt-col--1of3"> </div> <div class="Vlt-col--1of3"> </div> <div class="Vlt-col--1of3"> </div> </div> </div>
      HEREDOC

      # .squish() erb output to remove extranous newlines and whitespaces & .chomp trailing newline off expected_output
      expect(actual.squish).to eq(expected_output.chomp)
    end

    it 'renders the correct grid size when the last item in the grid has no explicit width' do
      @config = {
          'rows' => [
            {
              'columns' => [
                {
                  'width' => 1,
                  'entries' => [],
                },
                {
                  'entries' => [],
                },
              ],
            },
          ],
        }
      erb = File.read("#{Rails.root}/app/views/static/default_landing.html.erb")
      actual = ERB.new(erb).result(binding)

      puts actual.squish
      expected_output = <<~HEREDOC
        <div class=\"Vlt-grid\"> <div class=\"row\"> <div class=\"Vlt-col--1of2\"> </div> <div class=\"Vlt-col--1of2\"> </div> </div> </div>
      HEREDOC

      # .squish() erb output to remove extranous newlines and whitespaces & .chomp trailing newline off expected_output
      expect(actual.squish).to eq(expected_output.chomp)
    end
  end
end
