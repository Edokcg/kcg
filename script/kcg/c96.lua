--CNo.101 S・H・Dark Knight
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	aux.EnableCheckRankUp(c,nil,nil,48739166)
	Xyz.AddProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	  --cannot destroyed
		local e0=Effect.CreateEffect(c)
	  e0:SetType(EFFECT_TYPE_SINGLE)
	  e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	  e0:SetValue(s.indes)
	  c:RegisterEffect(e0)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12744567,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12744567,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--spsummon no.101
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13718,12))
	--e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.spcon2)
	--e3:SetCost(s.cost)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	e3:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_RANKUP_EFFECT)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)	
	--   local e4=Effect.CreateEffect(c)
	-- e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)	  
	-- e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	--   e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	--   e4:SetCondition(s.con)
	--   e4:SetOperation(s.op)
	--   c:RegisterEffect(e4)
end
s.xyz_number=101
s.listed_series = {0x48}
s.listed_names={48739166}

 function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end
function s.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (not c:IsSetCard(0x48) or c:IsSetCard(0x1048))
end
function s.descon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.desfilter,c:GetControler(),0,LOCATION_MZONE,1,c)
end
 function s.filter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,tc)
	end
end
 function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetOverlayCount()>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsLocation(LOCATION_GRAVE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local rec=e:GetHandler():GetBaseAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_GRAVE) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end

 function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0 
	--and e:GetHandler():GetFlagEffect(96)~=0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),e:GetHandler():GetOverlayCount(),REASON_COST)
end
function s.spovfilter(c,e,tp)
	return c:IsCode(48739166) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():CheckRemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),REASON_EFFECT) end
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g:GetFirst(),1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),e:GetHandler():GetOverlayCount(),REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not Duel.IsExistingMatchingCard(s.spovfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.spovfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	local c=e:GetHandler()
	if g and g:IsFaceup() and not g:IsImmuneToEffect(e) then
	  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

 function s.con(e,tp,eg,ep,ev,re,r,rp)
	  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and
	  e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,48739166) 
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	  e:GetHandler():RegisterFlagEffect(96,RESET_EVENT+0x1ff0000,0,1)
end