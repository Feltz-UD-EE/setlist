#
# Copyright 2025 John C. Feltz, github: Feltz-UD-EE/setlist
#
# Static routes
#
class StaticController < ApplicationController

    def public_home
        @bands = Band.all.alpha
    end

    def about
    end

    def credits
    end

    def legal
    end
end
