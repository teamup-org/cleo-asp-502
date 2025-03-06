RSpec.describe DegreePlannerController, type: :controller do
  include_context 'logged in student'
  include_context 'models setup'

  describe 'POST #upload_plan' do
    it 'imports courses successfully and redirects' do
      post :upload_plan,
           params: { student_google_id: student.google_id, file: fixture_file_upload('degree_plan.csv', 'text/csv') }

      expect(response).to redirect_to(student_degree_planner_path(student.google_id))
      expect(flash[:success]).to eq('Degree plan uploaded successfully')
    end
  end

  describe 'POST #upload_plan' do
    it 'imports courses rejected and redirects' do
      post :upload_plan,
           params: { student_google_id: student.google_id,
                     file: fixture_file_upload('invalid_degree_plan.csv', 'text/csv') }

      expect(response).to redirect_to(student_degree_planner_path(student.google_id))
      expect(flash[:error])
    end
  end

  describe 'GET #download_plan' do
    it 'downloads the degree plan as CSV' do
      get :download_plan, params: { student_google_id: student.google_id }

      expect(response).to have_http_status(:success)
      expect(response.header['Content-Type']).to include 'text/csv'
      expect(response.header['Content-Disposition']).to include 'attachment'
    end
  end
end
