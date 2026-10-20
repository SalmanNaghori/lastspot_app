// ========================================================
// CORE FLUTTER & ESSENTIAL THIRD-PARTY PACKAGES
// ========================================================
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:go_router/go_router.dart';

// ========================================================
// CORE CONSTANTS, BRANDING & ASSETS
// ========================================================
export '../gen/assets.gen.dart';
export 'constants/app_assets.dart';
export 'constants/app_constants.dart';
export 'constants/app_string.dart';
export 'constants/date_formats.dart';
export 'constants/dimensions.dart';

// ========================================================
// CORE THEME & MOTION SYSTEM
// ========================================================
export 'theme/app_color.dart';
export 'theme/app_motion.dart';
export 'theme/app_radius.dart';
export 'theme/app_spacing.dart';
export 'theme/app_theme.dart';
export 'theme/app_typography.dart';

// ========================================================
// CORE LOCALIZATION
// ========================================================
export 'l10n/app_localizations.dart';

// ========================================================
// CORE NAVIGATION & ROUTES
// ========================================================
export 'network/app_routes.dart';

// ========================================================
// CORE DEPENDENCY INJECTION & LOCAL STORAGE
// ========================================================
export 'di/service_locator.dart';
export 'utils/shared_prefs_util.dart';

// ========================================================
// CORE UTILITIES & EXTENSIONS
// ========================================================
export 'extension/date_extension.dart';
export 'extension/enum_extension.dart';
export 'extension/list_extension.dart';
export 'extension/map_extension.dart';
export 'extension/string_extension.dart';
export 'extension/theme_extension.dart';
export 'extension/widget_extension.dart';
export 'utils/app_utils.dart';
export 'utils/app_validators.dart';
export 'utils/context_extensions.dart';
export 'utils/result.dart';

// ========================================================
// CORE REUSABLE WIDGETS
// ========================================================
export 'widgets/activity_card.dart';
export 'widgets/activity_metadata_icon.dart';
export 'widgets/app_asset_image.dart';
export 'widgets/app_bottom_navigation.dart';
export 'widgets/app_cached_network_image.dart';
export 'widgets/app_empty_state.dart';
export 'widgets/app_error_state.dart';
export 'widgets/app_filter_chip.dart';
export 'widgets/app_loading.dart';
export 'widgets/app_network_image.dart';
export 'widgets/app_section_header.dart';
export 'widgets/app_section_title.dart';
export 'widgets/app_shimmer.dart';
export 'widgets/authenticated_app_shell.dart';
export 'widgets/bottom_sheets/app_bottom_sheet.dart';
export 'widgets/buttons/app_button.dart';
export 'widgets/cards/app_card.dart';
export 'widgets/category_3d_icon.dart';
export 'widgets/category_card.dart';
export 'widgets/custom_app_bar.dart';
export 'widgets/custom_segmented_control.dart';
export 'widgets/dialogs/app_dialog.dart';
export 'widgets/inputs/app_datetime_field.dart';
export 'widgets/inputs/app_text_field.dart';
export 'widgets/khelbhai_app_bar.dart';
export 'widgets/khelbhai_back_button.dart';
export 'widgets/brand_screen_title.dart';
export 'widgets/lastspot_bottom_navigation_bar.dart';
export 'widgets/responsive_layout.dart';
export 'widgets/selection_bottom_sheet.dart';
export 'widgets/sport_category_tile.dart';
export 'widgets/user_avatar.dart';
export 'widgets/user_profile_avatar.dart';
