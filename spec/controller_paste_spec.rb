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

    context 'Missing Paste' do
        it 'shows a not found page for an unknown paste' do
            get '/does-not-exist'

            expect(last_response.status).to eq 404
            expect(last_response.body).to include('Paste not found')
            expect(last_response.body).to include('Create new paste')
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

        it 'shows a copy link action on the created paste page' do
            post '/create', :paste => {lang: "javascript", content: "Copy this link"}
            get last_response.headers["Location"]

            expect(last_response.body).to include('id="copy-link"')
            expect(last_response.body).to include('Copy link')
        end

        it 'shows a copy content action on the created paste page' do
            post '/create', :paste => {lang: "javascript", content: "Copy this content"}
            get last_response.headers["Location"]

            expect(last_response.body).to include('id="copy-content"')
            expect(last_response.body).to include('Copy content')
        end
    end 
end
