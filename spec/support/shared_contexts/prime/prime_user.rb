shared_context 'Prime user' do
  let!(:prime_user) { create(:user, prime: true) }
end
