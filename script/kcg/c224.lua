--クロニクル・ソーサレス
--Chronicle Sorceress
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.spcon)
	c:RegisterEffect(e0)

	--Send 1 card from Deck to GY, based on Attributes in GY
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
    
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetTarget(s.dessptg)
	e5:SetOperation(s.desspop)
	c:RegisterEffect(e5)
end
local BEWD,DM=CARD_BLUEEYES_W_DRAGON,CARD_DARK_MAGICIAN
	--Mentions "Blue-Eyes White Dragon" and "Dark Magician"
s.listed_names={BEWD,DM,id,105}

function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_SPELLCASTER),c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function s.codefilter(c,code)
	return not c:IsCode(id) and (c:IsCode(code) or c:ListsCode(code)) and c:IsAbleToGrave()
end
	--Activation legality
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local light=Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_LIGHT)
	local dark=Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_DARK)
	local b1=light and Duel.IsExistingMatchingCard(s.codefilter,tp,LOCATION_DECK,0,1,nil,BEWD)
	local b2=dark and Duel.IsExistingMatchingCard(s.codefilter,tp,LOCATION_DECK,0,1,nil,DM)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
	--Send 1 card from Deck to GY, based on attributes in GY
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if e:GetLabel()==1 then
		g=Duel.SelectMatchingCard(tp,s.codefilter,tp,LOCATION_DECK,0,1,1,nil,BEWD)
	else
		g=Duel.SelectMatchingCard(tp,s.codefilter,tp,LOCATION_DECK,0,1,1,nil,DM)
	end
	if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
end

function s.dessptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsLevelAbove,5),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.desspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then return end
	c:SetEntityCode(105, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
	Duel.SpecialSummonComplete()
	c:CompleteProcedure()
end