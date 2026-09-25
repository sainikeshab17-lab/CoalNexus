import 'package:flutter/material.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/violations/domain/entities/corrective_action.dart';

enum SafetyWorkflowState {
  draft,
  inProgress,
  completed,
  findingsGenerated,
  violationCreated,
  correctiveActionAssigned,
  actionInProgress,
  actionSubmitted,
  verification,
  verified,
  rejected,
  closed,
}

class WorkflowService {
  // Inspection Transitions
  static bool canTransitionInspection(InspectionStatus from, InspectionStatus to) {
    switch (from) {
      case InspectionStatus.draft:
        return to == InspectionStatus.inProgress;
      case InspectionStatus.inProgress:
        return to == InspectionStatus.completed || to == InspectionStatus.draft;
      case InspectionStatus.completed:
        return to == InspectionStatus.findingsGenerated;
      case InspectionStatus.findingsGenerated:
        return to == InspectionStatus.submitted;
      case InspectionStatus.submitted:
        return false;
    }
  }

  // Corrective Action Transitions (Centralized Logic)
  static bool canTransitionCorrectiveAction(CorrectiveActionStatus from, CorrectiveActionStatus to) {
    switch (from) {
      case CorrectiveActionStatus.assigned:
        return to == CorrectiveActionStatus.inProgress;
      case CorrectiveActionStatus.inProgress:
        return to == CorrectiveActionStatus.submitted;
      case CorrectiveActionStatus.submitted:
        return to == CorrectiveActionStatus.verification;
      case CorrectiveActionStatus.verification:
        return to == CorrectiveActionStatus.verified || to == CorrectiveActionStatus.rejected;
      case CorrectiveActionStatus.verified:
        return to == CorrectiveActionStatus.closed;
      case CorrectiveActionStatus.rejected:
        return to == CorrectiveActionStatus.inProgress;
      case CorrectiveActionStatus.closed:
        return false;
    }
  }

  static String getStatusLabel(dynamic status) {
    if (status is InspectionStatus) {
      switch (status) {
        case InspectionStatus.draft: return 'DRAFT';
        case InspectionStatus.inProgress: return 'IN PROGRESS';
        case InspectionStatus.completed: return 'COMPLETED';
        case InspectionStatus.findingsGenerated: return 'FINDINGS GENERATED';
        case InspectionStatus.submitted: return 'SUBMITTED';
      }
    }
    if (status is CorrectiveActionStatus) {
      switch (status) {
        case CorrectiveActionStatus.assigned: return 'ASSIGNED';
        case CorrectiveActionStatus.inProgress: return 'ACTION IN PROGRESS';
        case CorrectiveActionStatus.submitted: return 'ACTION SUBMITTED';
        case CorrectiveActionStatus.verification: return 'VERIFICATION';
        case CorrectiveActionStatus.verified: return 'VERIFIED';
        case CorrectiveActionStatus.rejected: return 'REJECTED';
        case CorrectiveActionStatus.closed: return 'CLOSED';
      }
    }
    return status.toString().split('.').last.toUpperCase();
  }

  static Color getStatusColor(dynamic status) {
    if (status is InspectionStatus) {
      switch (status) {
        case InspectionStatus.draft: return Colors.grey;
        case InspectionStatus.inProgress: return Colors.blue;
        case InspectionStatus.completed: return Colors.green;
        case InspectionStatus.findingsGenerated: return Colors.orange;
        case InspectionStatus.submitted: return Colors.purple;
      }
    }
    if (status is CorrectiveActionStatus) {
      switch (status) {
        case CorrectiveActionStatus.assigned: return Colors.blue;
        case CorrectiveActionStatus.inProgress: return Colors.orange;
        case CorrectiveActionStatus.submitted: return Colors.indigo;
        case CorrectiveActionStatus.verification: return Colors.purple;
        case CorrectiveActionStatus.verified: return Colors.green;
        case CorrectiveActionStatus.rejected: return Colors.red;
        case CorrectiveActionStatus.closed: return Colors.teal;
      }
    }
    return Colors.grey;
  }
}
