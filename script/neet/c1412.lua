 --邪心英雄 复仇瘴魔(neet)
local s,id=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,{id,1})
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)   
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,{id,0})
	e3:SetCost(Cost.SelfBanish)
	e3:SetTarget(s.actg)
	e3:SetOperation(s.acop)
	c:RegisterEffect(e3)
end
s.listed_series={0x8}
s.listed_names={72043279}
function s.thfilter(c,ft,e,tp)
	return c:IsSetCard(0x8) and c:IsMonster()
		and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc,ft,e,tp) end
	local hg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x8):Filter(Card.IsMonster,nil)
	local b1=#hg>0
	local b2=Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_DAMAGE)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		local hg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x8):Filter(Card.IsMonster,nil)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(#hg*300)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,ft,e,tp)
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
		Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	else
		local sc=Duel.GetFirstTarget()
		if not sc:IsRelateToEffect(e) then return end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		if not sc then return end
		aux.ToHandOrElse(sc,tp,
			function(sc)
				return ft>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			end,
			function(sc)
				return Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end,
			aux.Stringid(id,2))
	end
end
function s.filter(c,tp)
	return c:IsCode(72043279) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
end