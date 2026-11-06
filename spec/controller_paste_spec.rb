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

        it 'offers visibility and password settings when creating a paste' do
            get '/'

            expect(last_response.body).to include('id="protected"')
            expect(last_response.body).to include('id="paste-password"')
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
        it 'requires a password for protected pastes' do
            post '/create', :paste => {
                lang: "javascript",
                content: "Missing password",
                protected: "1",
                password: ""
            }

            expect(last_response.status).to eq 422
            expect(last_response.body).to include('Protected pastes require a password')
        end

        it 'protects private pastes with a password prompt' do
            post '/create', :paste => {
                lang: "javascript",
                content: "Private content",
                protected: "1",
                password: "secret"
            }

            get last_response.headers["Location"]

            expect(last_response.status).to eq 200
            expect(last_response.body).to include('Protected paste')
            expect(last_response.body).to include('Enter password to view this paste')
            expect(last_response.body).to include('fa-lock')
        end

        it 'unlocks a private paste only with the configured password' do
            post '/create', :paste => {
                lang: "javascript",
                content: "Unlocked content",
                protected: "1",
                password: "secret"
            }
            paste_path = last_response.headers["Location"]

            post "#{paste_path}/unlock", :password => "wrong"
            expect(last_response.status).to eq 422
            expect(last_response.body).to include('Incorrect password')

            post "#{paste_path}/unlock", :password => "secret"
            expect(last_response.status).to be_between(300, 399)

            get paste_path
            expect(last_response.body).to include('Unlocked content')
        end

        it 'requires the password again after five minutes' do
            post '/create', :paste => {
                lang: "javascript",
                content: "Expiring content",
                protected: "1",
                password: "secret"
            }
            paste_path = last_response.headers["Location"]
            post "#{paste_path}/unlock", :password => "secret"

            current_time = Time.now
            allow(Time).to receive(:now).and_return(current_time, current_time + 301)
            get paste_path

            expect(last_response.body).to include('Enter password to view this paste')
        end

        it 'rejects an empty paste with an inline message' do
            post '/create', :paste => {lang: "javascript", content: "  "}

            expect(last_response.status).to eq 422
            expect(last_response.body).to include('Paste content cannot be empty')
            expect(last_response.body).to include('class="form-snackbar"')
            expect(last_response.body).to include('id="snackbar-container"')
        end

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
