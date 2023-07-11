require 'rails_helper'

require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:woman_user) { create(:user, :woman_user) }
  let(:man_user) { create(:user, :man_user) }
  let(:woman_only_event) { create(:event, :woman_only_event) }
  let(:regular_event) { create(:event) }

  describe '#can_join?' do
    context 'when the event is only for women' do
      context 'and the user is a woman' do
        it 'returns true' do
          expect(woman_only_event.can_join?(woman_user)).to be true
        end
      end

      context 'and the user is not a woman' do
        it 'returns false' do
          expect(woman_only_event.can_join?(man_user)).to be false
        end
      end
    end

    context 'when the event is not only for women' do
      context 'and the user is a woman' do
        it 'returns true' do
          expect(regular_event.can_join?(woman_user)).to be true
        end
      end

      context 'and the user is not a woman' do
        it 'returns true' do
          expect(regular_event.can_join?(man_user)).to be true
        end
      end
    end
  end
end
