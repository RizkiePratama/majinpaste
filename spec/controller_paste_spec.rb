require 'spec_helper'

describe PasteController do
    let(:app) {PasteController.new}
    before do
        @paste_path = ""
    end

    context 'Landing Page' do
        it 'GET "/" to Landing Page' do
            get '/'
            expect(last_response.status).to eq 200
        end
    end

    context 'Create new Paste' do
        it 'POST to "/create"' do
            post '/create', :paste => {lang: "javascript",content: "This is some test content"}
            expect(last_response.status).to eq 302
            @paste_path = last_response.headers["Location"]
        end

        it 'GET to Newly created Paste' do
            get @paste_path
            expect(last_response.status).to eq 200
        end
    end 
end