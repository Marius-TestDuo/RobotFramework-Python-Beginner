*** Variables ***

# -----------------------------------------------------------
#         Header
# -----------------------------------------------------------
${page_title}    css:[data-test='title']

# Navigation
${burger_menu}    id:react-burger-menu-btn
${nav_all_items}    css:[data-test='inventory-sidebar-link']
${nav_about}    css:[data-test='about-sidebar-link']
${nav_logout}    css:[data-test='logout-sidebar-link']
${nav_reset_app}    css:[data-test='reset-sidebar-link']

${header_cart}    css:[data-test='shopping-cart-link']    # could also be ${header_cart}    //a[@data-test='shopping-cart-link']

# -----------------------------------------------------------
#         Shopping page
# -----------------------------------------------------------

