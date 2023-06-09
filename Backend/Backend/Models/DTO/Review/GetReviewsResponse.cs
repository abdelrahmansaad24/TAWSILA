﻿using System.ComponentModel.DataAnnotations;

namespace Backend.Models.DTO.Review;

public record GetReviewsResponse(
        [Required] ReviewItem[] reviews,
        [Required] double averageRating,
        [Required] int TotalCount,
        [Required] int Offset
    );