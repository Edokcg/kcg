--水精鳞-深渊忒亚(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x74),1,1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,{id,0})
	e1:SetCost(s.cost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.cbcon)
	e2:SetTarget(s.cbtg)
	e2:SetOperation(s.cbop)
	c:RegisterEffect(e2)
	--change effect target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,1})
	e3:SetCondition(s.cecon)
	e3:SetTarget(s.cbtg)
	e3:SetOperation(s.ceop)
	c:RegisterEffect(e3)
end
function s.cfilter(c,e,tp)
	return c:IsMonster() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,c,e,tp,c:GetLevel())
end
function s.spfilter(c,e,tp,lv)
	return c:IsMonster() and c:IsSetCard(0x74) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsLevel(lv)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		--and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.cbcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsTurnPlayer(tp) then return false end
	local bc1,bc2=Duel.GetBattleMonster(tp)
	e:SetLabelObject(bc2)
	return bc1 and bc1:IsFaceup() and bc1:IsSetCard(0x74)
end
function s.spfilter2(c,e,tp,mc,pg)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x74) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and mc:IsCanBeXyzMaterial(c,tp) and (#pg<=0 or pg:IsContains(mc)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
		return #pg<=1 and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,pg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	if not (c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,pg):GetFirst()
	if not sc then return end
	sc:SetMaterial(c)
	Duel.Overlay(sc,c)
	if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		sc:CompleteProcedure()
	end
	if tc:CanAttack() and not tc:IsImmuneToEffect(e) then
		Duel.CalculateDamage(tc,sc)
	end
end
function s.cecon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return false end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc:GetControler()==1-tp or tc:IsFacedown() or not tc:IsLocation(LOCATION_MZONE) or not tc:IsSetCard(0x74) then return false end
	return true
end
function s.ceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	if not (c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,pg):GetFirst()
	if not sc then return end
	sc:SetMaterial(c)
	Duel.Overlay(sc,c)
	if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		sc:CompleteProcedure()
	end
	if Duel.CheckChainTarget(ev,sc) then
		Duel.ChangeTargetCard(ev,Group.FromCards(sc))
	end
end