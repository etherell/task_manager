# Models examples
RSpec.shared_examples 'an object with errors' do
  it 'returns appropriate error message' do
    object.update(data)
    expect(object.errors.to_a).to include(error_message)
  end
end

RSpec.shared_examples 'an object without errors' do
  it "doesn't return errors" do
    object.update(data)
    expect(object.errors.to_a).to be_empty
  end
end

# Requests examples
RSpec.shared_examples 'a not authorized error' do
  let(:another_user) { create(:user) }

  before do
    sign_out user
    sign_in another_user
    subject
  end

  it 'renders unauthorized partial' do
    expect(response).to render_template(partial: 'shared/_unauthorized')
  end

  it 'has unauthorized status' do
    expect(response.status).to eq(401)
  end

  it 'sets correct flash' do
    expect(flash[:error]).to eq('You are not authorized to access this page.')
  end
end

RSpec.shared_examples 'a correct params response' do
  before { subject }

  it 'has success status' do
    expect(response.status).to eq(200)
  end

  it 'adds success flash' do
    expect(flash[:success]).to eq(flash_message)
  end
end

RSpec.shared_examples 'an incorrect params response' do
  before { subject }

  it 'has unprocessable entity status' do
    expect(response.status).to eq(422)
  end

  it 'adds error flash' do
    expect(flash[:error]).to eq(flash_message)
  end
end

RSpec.shared_examples 'a not logged in error' do
  before do
    sign_out user
    subject
  end

  it 'has 302 status' do
    expect(response.status).to eq(302)
  end

  it 'redirects to log in page' do
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'returns appropriate flash' do
    expect(flash[:error]).to eq('Please, log in or sign up to continue')
  end
end
