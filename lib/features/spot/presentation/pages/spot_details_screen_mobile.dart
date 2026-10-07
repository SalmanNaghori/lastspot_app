import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/request_entity.dart';
import '../bloc/spot_details_bloc.dart';
import '../widgets/sport_gradient_background.dart';
import '../widgets/map_placeholder_painter.dart';
import '../widgets/spot_details_cta_button.dart';
import '../widgets/spot_details_menu_sheet.dart';

class SpotDetailsScreenMobile extends StatelessWidget {
  final SpotDetailsState state;
  final String? currentUserId;
  final String? heroTag;
  final bool showAppBar;
  final VoidCallback onBack;

  const SpotDetailsScreenMobile({
    super.key,
    required this.state,
    required this.currentUserId,
    this.heroTag,
    this.showAppBar = true,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;

    Widget content;
    if (state is SpotDetailsLoading || state is SpotDetailsInitial) {
      content = Scaffold(
        backgroundColor: showAppBar ? context.backgroundColor : Colors.transparent,
        appBar: showAppBar
            ? AppBar(
                leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
                title: Text(l10n.matchOverviewTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
              )
            : null,
        body: LoadingState.shimmerCard(),
      );
    } else if (state is SpotDetailsLoaded) {
      final loadedState = state as SpotDetailsLoaded;
      final post = loadedState.post;

      content = Scaffold(
        backgroundColor: showAppBar
            ? context.backgroundColor
            : Colors.transparent, // Fixes dark theme issue on mobile while preserving tablet transparency

        appBar: showAppBar
            ? AppBar(
                leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
                title: Text(l10n.matchOverviewTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      AppBottomSheet.show(
                        context: context,
                        builder: (_) => SpotDetailsMenuSheet(loadedState: loadedState),
                      );
                    },
                  ),
                ],
              )
            : null,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.r16.dynamicW),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images Carousel
              if (post.images.isNotEmpty) ...[
                Hero(
                  tag: heroTag ?? 'activity_image_${post.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
                    child: SizedBox(
                      height: Dimensions.r64.dynamicH * 3,
                      width: double.infinity,
                      child: PageView.builder(
                        itemCount: post.images.length,
                        itemBuilder: (context, index) {
                          return AppCachedNetworkImage(
                            imageUrl: post.images[index].storagePath,
                            fit: BoxFit.cover,
                            memCacheWidth: 800,
                            memCacheHeight: 800,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.r16.dynamicH),
              ] else ...[
                Hero(
                  tag: heroTag ?? 'activity_image_${post.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
                    child: SizedBox(
                      height: Dimensions.r64.dynamicH * 3,
                      width: double.infinity,
                      child: SportGradientBackground(categoryId: post.categoryId),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.r16.dynamicH),
              ],

              // Title Header
              Text(
                post.title.trim().isNotEmpty
                    ? post.title.trim().capitalizeFirst()
                    : AppUtils.getDisplayLocation(context, post.locationName, cityId: post.cityId),
                style: context.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: Dimensions.r8.dynamicH),
              Row(
                children: [
                  Text(
                    l10n.statusLabel(post.status.name.capitalizeFirst()),
                    style: context.bodyMedium?.copyWith(
                      color: post.status == RequestStatus.open ? AppColor.successColor : context.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    l10n.neededPlayers(post.maxParticipants - post.currentParticipants),
                    style: context.bodyMedium?.copyWith(
                      color: post.status == RequestStatus.open ? AppColor.successColor : context.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.r4.dynamicH),
              Text(
                l10n.hostedBy(post.hostProfile?.fullName ?? 'Anonymous'),
                style: context.bodyMedium?.copyWith(color: context.textSecondary),
              ),
              SizedBox(height: Dimensions.r8.dynamicH),

              // Price
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.r12.dynamicW, vertical: Dimensions.r6.dynamicH),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  border: Border.all(color: context.primaryColor.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.payments_outlined, size: Dimensions.r16.dynamicH, color: context.primaryColor),
                    SizedBox(width: Dimensions.r6.dynamicW),
                    Text(
                      post.pricePerPerson == 0
                          ? l10n.free
                          : '${AppUtils.formatCurrency(post.pricePerPerson)} ${l10n.perPerson}',
                      style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: context.primaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.r24.dynamicH),

              // Description (if present)
              if (post.description != null && post.description!.trim().isNotEmpty) ...[
                Text(
                  l10n.aboutSection,
                  style: context.labelLarge?.copyWith(color: context.textSecondary, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: Dimensions.r8.dynamicH),
                Text(post.description!, style: context.bodyMedium?.copyWith(height: 1.5)),
                SizedBox(height: Dimensions.r24.dynamicH),
              ],

              // Schedule
              Text(
                l10n.scheduleSection,
                style: context.labelLarge?.copyWith(color: context.textSecondary, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: Dimensions.r8.dynamicH),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: Dimensions.r20.dynamicH, color: context.textPrimary),
                  SizedBox(width: Dimensions.r12.dynamicW),
                  Text(AppUtils.formatDateTime(post.eventDateTime), style: context.titleMedium),
                ],
              ),
              SizedBox(height: Dimensions.r24.dynamicH),

              // Location
              Text(
                l10n.locationAndDirections.toUpperCase(),
                style: context.labelLarge?.copyWith(
                  color: context.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: Dimensions.r8.dynamicH),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
                  border: Border.all(color: context.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.blackColor.withValues(alpha: 0.04),
                      blurRadius: Dimensions.r10.dynamicR,
                      offset: Offset(0, Dimensions.r4.dynamicH),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Map Image Placeholder
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.r16.dynamicR)),
                      child: InkWell(
                        onTap: () => AppUtils.launchMap(post.locationName),
                        child: Container(
                          height: Dimensions.r64.dynamicH * 2.2,
                          width: double.infinity,
                          color: AppColor.successColor.withValues(alpha: 0.1),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: Size.infinite,
                                painter: MapPlaceholderPainter(color: AppColor.successColor.withValues(alpha: 0.2)),
                              ),
                              Icon(Icons.location_on, size: Dimensions.r32, color: AppColor.successColor),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title.trim().isNotEmpty ? post.title.trim() : 'Location',
                            style: context.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          SizedBox(height: Dimensions.r4.dynamicH),
                          GestureDetector(
                            onTap: () => AppUtils.launchMap(post.locationName),
                            child: Text(
                              AppUtils.getDisplayLocation(context, post.locationName, cityId: post.cityId),
                              style: context.bodyMedium?.copyWith(decoration: TextDecoration.underline),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: Dimensions.r16.dynamicH),
                          Divider(height: 1, color: context.borderColor),
                          SizedBox(height: Dimensions.r12.dynamicH),
                          InkWell(
                            onTap: () => AppUtils.launchMap(post.locationName),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(Dimensions.r8.dynamicW),
                                  decoration: BoxDecoration(
                                    color: AppColor.successColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                                  ),
                                  child: Icon(Icons.map, color: AppColor.successColor, size: Dimensions.r20.dynamicH),
                                ),
                                SizedBox(width: Dimensions.r12.dynamicW),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.viewOnMap,
                                        style: context.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        l10n.openInGoogleMaps,
                                        style: context.bodySmall?.copyWith(color: context.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right, color: context.textSecondary),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Confirmed Players
              SizedBox(height: Dimensions.h10),
              Text(
                l10n.confirmedPlayers(loadedState.confirmedPlayers.length, post.maxParticipants).toUpperCase(),
                style: context.labelLarge?.copyWith(
                  color: context.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: Dimensions.r12.dynamicH),
              Wrap(
                spacing: Dimensions.r16.dynamicW,
                runSpacing: Dimensions.r16.dynamicH,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  ...loadedState.confirmedPlayers.map(
                    (req) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.r12.dynamicW,
                            vertical: Dimensions.r6.dynamicH,
                          ),
                          decoration: BoxDecoration(
                            color: context.surfaceColor,
                            borderRadius: BorderRadius.circular(Dimensions.r24.dynamicR),
                            border: Border.all(color: context.borderColor),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.blackColor.withValues(alpha: 0.03),
                                blurRadius: Dimensions.r4.dynamicR,
                                offset: Offset(0, Dimensions.r2.dynamicH),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipOval(
                                child: req.userProfile?.avatarUrl != null
                                    ? AppCachedNetworkImage(
                                        imageUrl: req.userProfile!.avatarUrl!,
                                        width: Dimensions.r20.dynamicH,
                                        height: Dimensions.r20.dynamicH,
                                        fit: BoxFit.cover,
                                        memCacheWidth: 100,
                                        memCacheHeight: 100,
                                      )
                                    : Icon(Icons.person, size: Dimensions.r20.dynamicH, color: context.textSecondary),
                              ),
                              SizedBox(width: Dimensions.r8.dynamicW),
                              Text(
                                req.userProfile?.fullName ?? 'Player',
                                style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.r32.dynamicH),

              // Safety
              Text(
                l10n.safetyAndConduct.toUpperCase(),
                style: context.labelLarge?.copyWith(
                  color: context.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: Dimensions.r8.dynamicH),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
                  border: Border.all(color: context.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.blackColor.withValues(alpha: 0.02),
                      blurRadius: Dimensions.r8.dynamicR,
                      offset: Offset(0, Dimensions.r2.dynamicH),
                    ),
                  ],
                ),
                child: Material(
                  color: context.surfaceColor,
                  borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.shield_outlined, color: context.textPrimary, size: Dimensions.r20.dynamicH),
                        title: Text(
                          l10n.reportThisActivityOrHost,
                          style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: context.textSecondary,
                          size: Dimensions.r20.dynamicH,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.r16.dynamicR)),
                        ),
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        color: context.borderColor,
                        indent: Dimensions.r16.dynamicW,
                        endIndent: Dimensions.r16.dynamicW,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.menu_book_outlined,
                          color: context.textPrimary,
                          size: Dimensions.r20.dynamicH,
                        ),
                        title: Text(
                          l10n.learnAboutSafetyGuidelines,
                          style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: context.textSecondary,
                          size: Dimensions.r20.dynamicH,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(Dimensions.r16.dynamicR)),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: Dimensions.r48.dynamicH), // Padding for bottom
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.r16.dynamicW),
            child: SpotDetailsCtaButton(loadedState: loadedState),
          ),
        ),
      );
    } else {
      content = Scaffold(body: Center(child: Text(l10n.errorUnknownState)));
    }

    return content;
  }
}
