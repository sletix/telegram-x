module Bot
  module ActionRoute

    class PizzaSchema < DefaultSchema

      def show_pizza_menu
        @pizzas = [ "Hawaii pizza", "Veggie lovers", "Margherita", "Super pepperoni (best)" ]
        #@selected = processor.customer_data["selected"]
        @selected = false
        views.md_tpl_message "pizza_menu.md"
      end
    end
  end
end
