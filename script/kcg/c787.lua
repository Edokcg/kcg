--CXyz Barian, the King of Wishes
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,3,nil,nil,Xyz.InfiniteMats)
	c:EnableReviveLimit()

	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetCode(EFFECT_XYZ_LEVEL)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetRange(0xff&~LOCATION_MZONE)
	e01:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e01:SetTarget(s.xyztg)
	e01:SetValue(function(e,mc,rc) return rc==e:GetHandler() and 4,mc:GetLevel() or mc:GetLevel() end)
	c:RegisterEffect(e01)

	local e33=Effect.CreateEffect(c)
	e33:SetDescription(aux.Stringid(id,0))
	e33:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e33:SetType(EFFECT_TYPE_IGNITION)
	e33:SetRange(LOCATION_MZONE)
	e33:SetCountLimit(1)
	e33:SetCost(Cost.DetachFromSelf(function(e) return e:GetHandler():GetOverlayCount() end,function(e) return e:GetHandler():GetOverlayCount() end,function(e,og) e:SetLabel(#og) end))
	e33:SetTarget(s.c101target2)
	e33:SetOperation(s.c101operation2)
	c:RegisterEffect(e33)

	-- local e5=Effect.CreateEffect(c)
	-- e5:SetType(EFFECT_TYPE_SINGLE)
	-- e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e5:SetRange(LOCATION_MZONE)
	-- e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	-- e5:SetCondition(s.indcon)  
	-- e5:SetValue(aux.imval1) 
	-- c:RegisterEffect(e5)
	-- local e6=e5:Clone()
	-- e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	-- e6:SetCondition(s.indcon)  
	-- e6:SetValue(aux.tgoval)  
	-- c:RegisterEffect(e6)
end
s.listed_series={0x48,0x1048,0x1178}

function s.xyztg(e,c)
	local no=c.xyz_number
	return c:IsFaceup() and ((no and no>=101 and no<=107 and c:IsSetCard(0x48)) or c:GetLevel()==4)
end

function s.cnofilter(c,e,tp)
	return c.xyz_number and c.xyz_number>=101 and c.xyz_number<=107
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false,POS_FACEUP,1-tp) and c:IsSetCard(0x1048)
end
function s.c101target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(1-tp,tp,nil,TYPE_XYZ)>0 and Duel.IsExistingMatchingCard(s.cnofilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,tp,LOCATION_EXTRA)
end
function s.c101operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local ft=Duel.GetLocationCountFromEx(1-tp,tp,nil,TYPE_XYZ)
	if ft<=0 or ct<=0 then return end
	if Duel.IsPlayerAffectedByEffect(1-tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	ft=math.min(ft,aux.CheckSummonGate(1-tp) or ft)
	ft=math.min(ft,ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.cnofilter,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp)
	if #g>0 then
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(3312)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e5=e3:Clone()
			e5:SetDescription(3310)
			e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e5)
			local e6=e5:Clone()
			e6:SetDescription(3309)
			e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			tc:RegisterEffect(e6)
		end
		Duel.SpecialSummonComplete()
	end
end

function s.pnofilters(c)
	local no=c.xyz_number
	return no and no>=101 and no<=107 and c:IsSetCard(0x1048) and c:IsFaceup()
end
function s.indcon(e)  
	return Duel.IsExistingMatchingCard(s.pnofilters,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())  
end  