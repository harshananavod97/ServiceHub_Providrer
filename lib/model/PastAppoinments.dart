// To parse this JSON data, do
//
//     final pastApoinmentList = pastApoinmentListFromJson(jsonString);

import 'dart:convert';

List<PastApoinmentList> pastApoinmentListFromJson(String str) => List<PastApoinmentList>.from(json.decode(str).map((x) => PastApoinmentList.fromJson(x)));

String pastApoinmentListToJson(List<PastApoinmentList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PastApoinmentList {
    int id;
    int serviceCategoryId;
    int customerId;
    DateTime requestDate;
    DateTime appointmentDateTime;
    int customerAddressId;
    String estimatedBudget;
    String jobType;
    String addtionalInfo;
    String jobStatus;
    String paymentStatus;
    int selectedServiceProviderId;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic jobRating;
    CustomerAddress customerAddress;
    ServiceCategory serviceCategory;
    ServiceProvider serviceProvider;
    JobPayment jobPayment;
    List<dynamic> complaint;

    PastApoinmentList({
        required this.id,
        required this.serviceCategoryId,
        required this.customerId,
        required this.requestDate,
        required this.appointmentDateTime,
        required this.customerAddressId,
        required this.estimatedBudget,
        required this.jobType,
        required this.addtionalInfo,
        required this.jobStatus,
        required this.paymentStatus,
        required this.selectedServiceProviderId,
        required this.createdAt,
        required this.updatedAt,
        required this.jobRating,
        required this.customerAddress,
        required this.serviceCategory,
        required this.serviceProvider,
        required this.jobPayment,
        required this.complaint,
    });

    factory PastApoinmentList.fromJson(Map<String, dynamic> json) => PastApoinmentList(
        id: json["id"],
        serviceCategoryId: json["service_category_id"],
        customerId: json["customer_id"],
        requestDate: DateTime.parse(json["request_date"]),
        appointmentDateTime: DateTime.parse(json["appointment_date_time"]),
        customerAddressId: json["customer_address_id"],
        estimatedBudget: json["estimated_budget"],
        jobType: json["job_type"],
        addtionalInfo: json["addtional_info"],
        jobStatus: json["job_status"],
        paymentStatus: json["payment_status"],
        selectedServiceProviderId: json["selected_service_provider_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        jobRating: json["job_rating"],
        customerAddress: CustomerAddress.fromJson(json["customer_address"]),
        serviceCategory: ServiceCategory.fromJson(json["service_category"]),
        serviceProvider: ServiceProvider.fromJson(json["service_provider"]),
        jobPayment: JobPayment.fromJson(json["job_payment"]),
        complaint: List<dynamic>.from(json["complaint"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "service_category_id": serviceCategoryId,
        "customer_id": customerId,
        "request_date": requestDate.toIso8601String(),
        "appointment_date_time": appointmentDateTime.toIso8601String(),
        "customer_address_id": customerAddressId,
        "estimated_budget": estimatedBudget,
        "job_type": jobType,
        "addtional_info": addtionalInfo,
        "job_status": jobStatus,
        "payment_status": paymentStatus,
        "selected_service_provider_id": selectedServiceProviderId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "job_rating": jobRating,
        "customer_address": customerAddress.toJson(),
        "service_category": serviceCategory.toJson(),
        "service_provider": serviceProvider.toJson(),
        "job_payment": jobPayment.toJson(),
        "complaint": List<dynamic>.from(complaint.map((x) => x)),
    };
}

class CustomerAddress {
    int id;
    String addressType;
    String address1;
    String address2;
    String city;
    String ing;
    String lat;
    int customerId;
    DateTime createdAt;
    DateTime updatedAt;

    CustomerAddress({
        required this.id,
        required this.addressType,
        required this.address1,
        required this.address2,
        required this.city,
        required this.ing,
        required this.lat,
        required this.customerId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory CustomerAddress.fromJson(Map<String, dynamic> json) => CustomerAddress(
        id: json["id"],
        addressType: json["address_type"],
        address1: json["address_1"],
        address2: json["address_2"],
        city: json["city"],
        ing: json["ing"],
        lat: json["lat"],
        customerId: json["customer_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "address_type": addressType,
        "address_1": address1,
        "address_2": address2,
        "city": city,
        "ing": ing,
        "lat": lat,
        "customer_id": customerId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class JobPayment {
    int id;
    int jobId;
    String paymentMethod;
    DateTime paymentDate;
    String paymentRef;
    String paidAmount;
    String companyAmount;
    String providerAmount;
    String collectionStatus;
    String payoutStatus;
    int customerId;
    int serviceProviderId;
    DateTime createdAt;
    DateTime updatedAt;

    JobPayment({
        required this.id,
        required this.jobId,
        required this.paymentMethod,
        required this.paymentDate,
        required this.paymentRef,
        required this.paidAmount,
        required this.companyAmount,
        required this.providerAmount,
        required this.collectionStatus,
        required this.payoutStatus,
        required this.customerId,
        required this.serviceProviderId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory JobPayment.fromJson(Map<String, dynamic> json) => JobPayment(
        id: json["id"],
        jobId: json["job_id"],
        paymentMethod: json["payment_method"],
        paymentDate: DateTime.parse(json["payment_date"]),
        paymentRef: json["payment_ref"],
        paidAmount: json["paid_amount"],
        companyAmount: json["company_amount"],
        providerAmount: json["provider_amount"],
        collectionStatus: json["collection_status"],
        payoutStatus: json["payout_status"],
        customerId: json["customer_id"],
        serviceProviderId: json["service_provider_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "payment_method": paymentMethod,
        "payment_date": paymentDate.toIso8601String(),
        "payment_ref": paymentRef,
        "paid_amount": paidAmount,
        "company_amount": companyAmount,
        "provider_amount": providerAmount,
        "collection_status": collectionStatus,
        "payout_status": payoutStatus,
        "customer_id": customerId,
        "service_provider_id": serviceProviderId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class JobRatingClass {
    int id;
    int jobId;
    int serviceProviderId;
    int rating;
    String comment;
    DateTime createdAt;
    DateTime updatedAt;
    int customerId;

    JobRatingClass({
        required this.id,
        required this.jobId,
        required this.serviceProviderId,
        required this.rating,
        required this.comment,
        required this.createdAt,
        required this.updatedAt,
        required this.customerId,
    });

    factory JobRatingClass.fromJson(Map<String, dynamic> json) => JobRatingClass(
        id: json["id"],
        jobId: json["job_id"],
        serviceProviderId: json["service_provider_id"],
        rating: json["rating"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        customerId: json["customer_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "service_provider_id": serviceProviderId,
        "rating": rating,
        "comment": comment,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "customer_id": customerId,
    };
}

class ServiceCategory {
    int id;
    String name;
    String payoutRate;
    DateTime createdAt;
    DateTime updatedAt;

    ServiceCategory({
        required this.id,
        required this.name,
        required this.payoutRate,
        required this.createdAt,
        required this.updatedAt,
    });

    factory ServiceCategory.fromJson(Map<String, dynamic> json) => ServiceCategory(
        id: json["id"],
        name: json["name"],
        payoutRate: json["payout_rate"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "payout_rate": payoutRate,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class ServiceProvider {
    int id;
    String fullName;
    String email;
    dynamic emailVerifiedAt;
    String password;
    String nic;
    String address1;
    String address2;
    String city;
    int serviceCategoryId;
    String profilePic;
    String description;
    dynamic rememberToken;
    DateTime createdAt;
    DateTime updatedAt;
    String phoneNumber;
    int generatedOtp;
    String fcmKey;

    ServiceProvider({
        required this.id,
        required this.fullName,
        required this.email,
        this.emailVerifiedAt,
        required this.password,
        required this.nic,
        required this.address1,
        required this.address2,
        required this.city,
        required this.serviceCategoryId,
        required this.profilePic,
        required this.description,
        this.rememberToken,
        required this.createdAt,
        required this.updatedAt,
        required this.phoneNumber,
        required this.generatedOtp,
        required this.fcmKey,
    });

    factory ServiceProvider.fromJson(Map<String, dynamic> json) => ServiceProvider(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        password: json["password"],
        nic: json["nic"],
        address1: json["address_1"],
        address2: json["address_2"],
        city: json["city"],
        serviceCategoryId: json["service_category_id"],
        profilePic: json["profile_pic"],
        description: json["description"],
        rememberToken: json["remember_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        phoneNumber: json["phone_number"],
        generatedOtp: json["generated_otp"],
        fcmKey: json["fcm_key"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "password": password,
        "nic": nic,
        "address_1": address1,
        "address_2": address2,
        "city": city,
        "service_category_id": serviceCategoryId,
        "profile_pic": profilePic,
        "description": description,
        "remember_token": rememberToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "phone_number": phoneNumber,
        "generated_otp": generatedOtp,
        "fcm_key": fcmKey,
    };
}
