require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Review. As you add validations to Review, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      user_id: create(:user).id
    }
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  before(:each) do
    login_admin
  end

  describe "GET #index" do
    it "assigns all reviews as @reviews" do
      review = create :review
      get :index, {}
      expect(assigns(:reviews)).to eq([review])
    end
  end

  describe "GET #show" do
    it "assigns the requested review as @review" do
      review = Review.create! valid_attributes
      get :show, {:id => review.to_param}
      expect(assigns(:review)).to eq(review)
    end
  end

  describe "GET #new" do
    it "assigns a new review as @review" do
      get :new, {}
      expect(assigns(:review)).to be_a_new(Review)
    end
  end

  describe "GET #edit" do
    it "assigns the requested review as @review" do
      review = Review.create! valid_attributes
      get :edit, {:id => review.to_param}
      expect(assigns(:review)).to eq(review)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Review" do
        expect {
          post :create, {:review => valid_attributes}
        }.to change(Review, :count).by(1)
      end

      it "assigns a newly created review as @review" do
        post :create, {:review => valid_attributes}
        expect(assigns(:review)).to be_a(Review)
        expect(assigns(:review)).to be_persisted
      end

      it "redirects to the created review" do
        post :create, {:review => valid_attributes}
        expect(response).to redirect_to(Review.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved review as @review" do
        post :create, {:review => invalid_attributes}
        expect(assigns(:review)).to be_a_new(Review)
      end

      it "re-renders the 'new' template" do
        post :create, {:review => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested review" do
        review = Review.create! valid_attributes
        put :update, {:id => review.to_param, :review => new_attributes}
        review.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested review as @review" do
        review = Review.create! valid_attributes
        put :update, {:id => review.to_param, :review => valid_attributes}
        expect(assigns(:review)).to eq(review)
      end

      it "redirects to the review" do
        review = Review.create! valid_attributes
        put :update, {:id => review.to_param, :review => valid_attributes}
        expect(response).to redirect_to(review)
      end
    end

    context "with invalid params" do
      it "assigns the review as @review" do
        review = Review.create! valid_attributes
        put :update, {:id => review.to_param, :review => invalid_attributes}
        expect(assigns(:review)).to eq(review)
      end

      it "re-renders the 'edit' template" do
        review = Review.create! valid_attributes
        put :update, {:id => review.to_param, :review => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested review" do
      review = Review.create! valid_attributes
      expect {
        delete :destroy, {:id => review.to_param}
      }.to change(Review, :count).by(-1)
    end

    it "redirects to the reviews list" do
      review = Review.create! valid_attributes
      delete :destroy, {:id => review.to_param}
      expect(response).to redirect_to(reviews_url)
    end
  end

end
