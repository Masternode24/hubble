require 'rails_helper'

describe 'User Auth' do
  let(:user) { create :user }

  before do
    visit login_path
  end

  context 'without mfa' do
    it 'shows an error on invalid password' do
      fill_in 'email', with: user.email
      fill_in 'password', with: 'foobar'
      click_on 'login'

      expect(page).to have_current_path login_path
      expect(page).to have_content 'Invalid email or password.'
    end

    it 'logs user in' do
      fill_in 'email', with: user.email
      fill_in 'password', with: '12345678'
      click_on 'login'

      expect(page).to have_current_path root_path
      expect(page).to have_content 'Account'

      visit(settings_users_path)
      expect(page).to have_content 'User Info'
    end
  end

  context 'with mfa' do
    let(:user) { create :user, otp_enabled: true }

    before do
      allow_any_instance_of(User).to receive(:authenticate_otp).with('BAD').and_return(false)
      allow_any_instance_of(User).to receive(:authenticate_otp).with('GOOD').and_return(true)

      fill_in 'email', with: user.email
      fill_in 'password', with: '12345678'
      click_on 'login'
    end

    it 'redirects to otp verification page' do
      expect(page).to have_current_path login_verify_path
    end

    it 'resets mfa session after X failed attempts' do
      failures = 0

      10.times do
        fill_in 'otp_code', with: 'BAD'
        click_on 'verify'

        break if page.current_path != login_verify_path

        failures += 1
        expect(page).to have_current_path login_verify_path
      end

      visit(login_verify_path)
      expect(page).to have_current_path root_path
      expect(failures).to eq 5
    end

    it 'logs user in' do
      fill_in 'otp_code', with: 'GOOD'
      click_on 'verify'

      expect(page).to have_current_path root_path
      expect(page).to have_content 'Account'

      visit(settings_users_path)
      expect(page).to have_content 'User Info'

      visit(login_verify_path)
      expect(page).to have_current_path root_path
    end
  end
end
